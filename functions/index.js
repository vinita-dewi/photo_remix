// Firebase Cloud Functions entry point.
// Uses Secret Manager for API keys; supports Functions emulator.

const functions = require('firebase-functions');
const { onCall } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const { GoogleGenerativeAI } = require('@google/generative-ai');

const externalApiKey = defineSecret('EXTERNAL_API_KEY');
const STUB_IMAGES = [
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d',
  'https://images.unsplash.com/photo-1498050108023-c5249f4df085',
  'https://images.unsplash.com/photo-1511765224389-37f0e77cf0eb',
  'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
];

exports.generateImage = onCall({ secrets: [externalApiKey] }, async (request) => {
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

  const apiKey = externalApiKey.value();
  const useStub = !apiKey || process.env.USE_STUB === 'true';

  // Stub mode: return placeholder images so the flow works without billing/key.
  if (useStub) {
    functions.logger.warn('Using stub images (no API key or USE_STUB=true)');
    return {
      count: STUB_IMAGES.length,
      images: STUB_IMAGES.map((url) => ({
        base64: null,
        mimeType: 'image/jpeg',
        url,
      })),
      stub: true,
    };
  }

  const genAI = new GoogleGenerativeAI(apiKey);
  const model = genAI.getGenerativeModel({
    model: 'models/gemini-2.0-flash',
    generationConfig: { candidateCount: 4 },
  });

  const prompt = `You are an advanced image-editing model (Nano Banana / Gemini 2.5 Flash Image).

Task:
- Use the provided image as the base reference.
- Transform it into the visual style of the category: "${category}".
- Preserve the main subject and its structure so it stays recognizable.
- Keep overall composition similar, unless the category requires a different framing.
- Do NOT add visible text or watermarks unless the category explicitly asks for it.
- Return exactly four edited image`;

  try {
    const response = await model.generateContent({
      contents: [
        {
          role: 'user',
          parts: [
            { text: prompt },
            {
              inlineData: {
                data: imageBase64,
                mimeType: mimeType || 'image/jpeg',
              },
            },
          ],
        },
      ],
    });

    const images = [];
    const candidates = response?.response?.candidates || [];
    for (const cand of candidates) {
      const parts = cand?.content?.parts || [];
      for (const part of parts) {
        if (part.inlineData?.data) {
          images.push({
            base64: part.inlineData.data,
            mimeType: part.inlineData.mimeType || mimeType || 'image/jpeg',
          });
        }
      }
      if (images.length >= 4) break;
    }

    if (images.length === 0) {
      throw new Error('No images returned from Gemini.');
    }

    return {
      count: images.length,
      images,
    };
  } catch (err) {
    functions.logger.error('generateImage failed', err);
    throw new functions.https.HttpsError(
      'internal',
      err.message || 'Image generation failed'
    );
  }
});
