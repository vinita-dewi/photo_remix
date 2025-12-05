import 'package:photo_remix/features/image_generation/domain/models/category.dart';

/// Predefined categories for prompts/styles.
final List<Category> kImageCategories = [
  // Travel & leisure
  Category(id: 'beach_trip', name: 'Beach Trip'),
  Category(id: 'road_trip', name: 'Road Trip'),
  Category(id: 'city_explorer', name: 'City Explorer'),
  Category(id: 'mountain_getaway', name: 'Mountain Getaway'),
  Category(id: 'camping_outdoors', name: 'Camping & Outdoors'),
  Category(id: 'luxury_vacation', name: 'Luxury Vacation'),
  Category(id: 'backpacker_journey', name: 'Backpacker Journey'),
  Category(id: 'tropical_paradise', name: 'Tropical Paradise'),
  Category(id: 'european_old_town', name: 'European Old Town'),
  Category(id: 'desert_escape', name: 'Desert Escape'),

  // Lifestyle
  Category(id: 'casual_day_out', name: 'Casual Day Out'),
  Category(id: 'work_productivity', name: 'Work & Productivity'),
  Category(id: 'cafe_aesthetic', name: 'Cafe Aesthetic'),
  Category(id: 'gym_fitness', name: 'Gym & Fitness'),
  Category(id: 'self_care_wellness', name: 'Self-Care & Wellness'),
  Category(id: 'morning_routine', name: 'Morning Routine'),
  Category(id: 'night_out', name: 'Night Out'),
  Category(id: 'family_time', name: 'Family Time'),
  Category(id: 'pet_moments', name: 'Pet Moments'),
  Category(id: 'foodie_shot', name: 'Foodie Shot'),

  // Events
  Category(id: 'birthday_party', name: 'Birthday Party'),
  Category(id: 'wedding_vibes', name: 'Wedding Vibes'),
  Category(id: 'festival_concert', name: 'Festival & Concert'),
  Category(id: 'holiday_celebration', name: 'Holiday Celebration'),
  Category(id: 'graduation_moment', name: 'Graduation Moment'),
  Category(id: 'romantic_date', name: 'Romantic Date'),
  Category(id: 'friends_hangout', name: 'Friends Hangout'),
  Category(id: 'new_year_countdown', name: 'New Year Countdown'),

  // Looks & moods
  Category(id: 'minimalist_clean', name: 'Minimalist Clean'),
  Category(id: 'moody_cinematic', name: 'Moody & Cinematic'),
  Category(id: 'soft_pastel', name: 'Soft Pastel'),
  Category(id: 'warm_cozy', name: 'Warm & Cozy'),
  Category(id: 'vintage_film', name: 'Vintage Film'),
  Category(id: 'polaroid_style', name: 'Polaroid Style'),
  Category(id: 'street_style', name: 'Street Style'),
  Category(id: 'editorial_magazine', name: 'Editorial / Magazine'),
  Category(id: 'luxury_premium', name: 'Luxury & Premium'),
  Category(id: 'cyberpunk_neon', name: 'Cyberpunk Neon'),
  Category(id: 'dark_mode', name: 'Dark Mode'),
  Category(id: 'boho_vibes', name: 'Boho Vibes'),

  // Art styles
  Category(id: 'digital_painting', name: 'Digital Painting'),
  Category(id: 'watercolor_art', name: 'Watercolor Art'),
  Category(id: 'comic_pop_art', name: 'Comic / Pop Art'),
  Category(id: 'anime_manga', name: 'Anime / Manga Style'),
  Category(id: 'oil_painting', name: 'Oil Painting Classic'),
  Category(id: 'sketch_line', name: 'Sketch & Line Art'),
  Category(id: 'collage_style', name: 'Collage Style'),
  Category(id: 'surreal_dreamy', name: 'Surreal & Dreamy'),
  Category(id: 'render_3d', name: '3D Render Look'),
  Category(id: 'glitch_vaporwave', name: 'Glitch & Vaporwave'),

  // Content types
  Category(id: 'influencer_portrait', name: 'Influencer Portrait'),
  Category(id: 'brand_highlight', name: 'Brand/Product Highlight'),
  Category(id: 'flat_lay', name: 'Flat Lay Content'),
  Category(id: 'before_after', name: 'Before & After Glow-Up'),
  Category(id: 'thumbnail_style', name: 'Thumbnail Style (YouTube/TikTok)'),
  Category(id: 'quote_background', name: 'Quote Background'),
  Category(id: 'story_cover', name: 'Story / Reel Cover'),
  Category(id: 'bts', name: 'Behind The Scenes'),
  Category(id: 'ugc_style', name: 'UGC (User-Generated Content) Style'),

  // Seasons & holidays
  Category(id: 'summer_vibes', name: 'Summer Vibes'),
  Category(id: 'autumn_mood', name: 'Autumn Mood'),
  Category(id: 'winter_wonderland', name: 'Winter Wonderland'),
  Category(id: 'spring_bloom', name: 'Spring Bloom'),
  Category(id: 'halloween_theme', name: 'Halloween Theme'),
  Category(id: 'christmas_holiday', name: 'Christmas & Holiday'),
  Category(id: 'valentines_day', name: "Valentine's Day"),

  // Professional
  Category(id: 'linkedin_headshot', name: 'LinkedIn Headshot'),
  Category(id: 'startup_founder', name: 'Startup Founder Vibe'),
  Category(id: 'creator_studio', name: 'Content Creator Studio'),
  Category(id: 'tech_coding', name: 'Tech & Coding'),
  Category(id: 'speaker_coach', name: 'Speaker / Coach'),
  Category(id: 'portfolio_cv', name: 'Portfolio / CV Photo'),

  // Fantasy & entertainment
  Category(id: 'fantasy_world', name: 'Fantasy World'),
  Category(id: 'superhero_poster', name: 'Superhero Poster'),
  Category(id: 'sci_fi', name: 'Sci-Fi Futuristic'),
  Category(id: 'gaming_setup', name: 'Gaming Setup'),
  Category(id: 'kpop_inspired', name: 'K-Pop Inspired'),
  Category(id: 'music_cover', name: 'Music Cover Art'),
];
