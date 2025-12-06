// Firebase Cloud Functions entry point.
// Uses Secret Manager for API keys; supports Functions emulator.

const functions = require('firebase-functions');
const { onCall } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');

// Secret for the inference provider (Hugging Face Inference API token).
const hfToken = defineSecret('HF_TOKEN');

exports.generateImage = onCall({ secrets: [hfToken] }, async (request) => {
  const { data, auth } = request || {};
  const { category, imageBase64, mimeType } = data || {};

  functions.logger.info('generateImage payload', {
    category,
    hasImage: !!imageBase64,
    imageLength: imageBase64 ? imageBase64.length : 0,
    mimeType,
    uid: auth?.uid,
  });

  if (!category || !imageBase64) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing required fields: category, imageBase64'
    );
  }

  const token = hfToken.value();
  if (!token) {
    throw new functions.https.HttpsError(
      'failed-precondition',
      'HF_TOKEN is not configured'
    );
  }

  const modelId =
    process.env.HF_MODEL_ID || 'stabilityai/stable-diffusion-xl-base-1.0';
  const prompt = `Task:
- Use the provided image as the base reference.
- Transform it into the visual style of the category: "${category}".
- Preserve the main subject and its structure so it stays recognizable.
- Keep overall composition similar, unless the category requires a different framing.
- Do NOT add visible text or watermarks unless the category explicitly asks for it.
- Return exactly four edited image`;

  try {
    const response = await fetch(
      `https://router.huggingface.co/hf-inference/models/${modelId}`,
      {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          inputs: prompt,
          image: imageBase64, // base64 without data: prefix
          parameters: {
            num_images: 1,
            // Lower strength/guidance to preserve the source subject.
            strength: 0.35,
            guidance_scale: 3.0,
            num_inference_steps: 10,
          },
        }),
      }
    );

    if (!response.ok) {
      const errText = await response.text();
      throw new Error(
        `HF inference failed: ${response.status} ${errText}`
      );
    }

    const contentType = response.headers.get('content-type') || '';
    let images = [];

    if (contentType.includes('application/json')) {
      const body = await response.json();
      const rawImages = (body?.images ?? body ?? []).slice(0, 1);
      images = rawImages
        .map((img) => ({
          base64: typeof img === 'string' ? img : img?.base64,
          mimeType: mimeType || 'image/png',
        }))
        .filter((img) => img.base64);
    } else {
      const buffer = Buffer.from(await response.arrayBuffer());
      images = [
        {
          base64: buffer.toString('base64'),
          mimeType: contentType.split(';')[0] || mimeType || 'image/png',
        },
      ];
    }

    if (images.length === 0) {
      throw new Error('No images returned from inference provider.');
    }

    return {
      count: images.length,
      images,
    };
  } catch (err) {
    const msg =
      typeof err === 'string'
        ? err
        : err?.message ||
          err?.response ||
          err?.toString() ||
          'Image generation failed';
    functions.logger.error('generateImage failed', {
      message: msg,
      model: modelId,
      hasToken: !!token,
    });
    throw new functions.https.HttpsError('internal', msg, { message: msg });
  }
});
