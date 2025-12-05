// Firebase Cloud Functions entry point.
// Callable to generate an image; currently a stub that echoes the request.

const functions = require('firebase-functions');

exports.generateImage = functions.https.onCall(async (data, context) => {
  // TODO: implement actual generation logic (invoke ML service, etc.).
  // Expecting payload fields: categoryId, categoryName, imagePath.
  const { categoryId, categoryName, imagePath } = data || {};

  if (!categoryId || !categoryName || !imagePath) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing required fields: categoryId, categoryName, imagePath'
    );
  }

  return {
    message: 'generateImage stub received request',
    categoryId,
    categoryName,
    imagePath,
  };
});
