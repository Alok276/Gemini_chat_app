import 'dart:math';

import 'package:dio/dio.dart';
import 'package:gemini_chat_app/models/chat_message_model.dart';
import 'package:gemini_chat_app/utils/constants.dart';

class ChatRepo {
  static Future<String> chatTextGenerationRepo(
      List<ChatMessageModel> previousMessages) async {
    try {
      Dio dio = Dio();
      final response = await dio.post(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey",
          data: {
            "contents": [
              {
                "role": "user",
                "parts": [
                  {"text": "The science of universe beyond earth"}
                ]
              },
              {
                "role": "model",
                "parts": [
                  {
                    "text":
                        "## The Science of the Universe Beyond Earth: A Vast and Ever-Expanding Field\n\nThe study of the universe beyond Earth is a vast and complex field, encompassing numerous disciplines like astronomy, astrophysics, cosmology, and planetary science. It'\''s an ever-expanding field of knowledge, fueled by cutting-edge technologies and driven by humanity'\''s insatiable curiosity about the cosmos.\n\nHere'\''s a glimpse into some key areas of study:\n\n**1. Planets and Planetary Systems:**\n\n* **Exoplanets:**  The discovery of planets orbiting other stars, called exoplanets, has revolutionized our understanding of planetary formation and the potential for life beyond Earth.  \n* **Planet Formation:**  Scientists are studying how planets form from swirling disks of gas and dust around young stars, revealing the conditions necessary for habitable worlds.\n* **Planetary Atmospheres:** Studying the atmospheres of planets can reveal their composition, climate, and even the presence of potential biosignatures (signs of life).\n\n**2. Stars and Stellar Evolution:**\n\n* **Stellar Birth and Death:** From the birth of stars in massive clouds of gas and dust to their eventual demise as white dwarfs, neutron stars, or black holes, scientists are unraveling the life cycles of stars.\n* **Star Clusters:** Studying star clusters, groups of stars born at the same time, helps us understand how stars evolve and interact with each other.\n* **Supernovae:** The explosive death of massive stars, called supernovae, release enormous amounts of energy and heavy elements, contributing to the chemical composition of the universe.\n\n**3. Galaxies and Cosmology:**\n\n* **Galaxy Formation and Evolution:**  Scientists are piecing together how galaxies form and evolve over billions of years, revealing the intricate interplay of gravity, dark matter, and the expansion of the universe.\n* **Cosmic Microwave Background (CMB):**  This faint afterglow of the Big Bang provides crucial information about the early universe, its composition, and the expansion rate.\n* **Dark Matter and Dark Energy:**  The mysterious components of the universe, dark matter and dark energy, play a crucial role in shaping the structure and evolution of the cosmos, but their exact nature remains a mystery.\n\n**4. Black Holes and Neutron Stars:**\n\n* **Black Holes:**  These regions of extreme gravity where not even light can escape are fascinating objects that test the limits of our understanding of physics.\n* **Neutron Stars:** The incredibly dense remnants of massive stars after they explode as supernovae, these objects are powerful sources of radio waves and X-rays.\n\n**5. Search for Life Beyond Earth:**\n\n* **Astrobiology:** This interdisciplinary field focuses on the origin, evolution, and distribution of life in the universe.\n* **Exobiological Research:**  Scientists are studying the potential for life on other planets and moons, searching for signs of past or present life.\n\n**Tools of the Trade:**\n\n* **Telescopes:** Ground-based and space-based telescopes, from radio to infrared to optical, provide a wide range of wavelengths for studying celestial objects.\n* **Spacecraft:** Missions to planets, moons, and even asteroids provide close-up observations and sample collection.\n* **Computer Modeling and Simulations:**  Computer simulations help scientists model complex processes and phenomena in the universe.\n\n**The Future of Exploring the Universe:**\n\n* **Next Generation Telescopes:**  The next generation of telescopes, like the James Webb Space Telescope (JWST), promise to revolutionize our understanding of the universe.\n* **Space Exploration:**  Missions to Mars and other destinations in our solar system will continue to expand our knowledge of the cosmos.\n* **Technological Advancements:**  Continued development of new technologies, like interferometry and gravitational wave detection, will unlock new frontiers in space exploration.\n\nThe science of the universe beyond Earth is a constantly evolving field, driven by technological advancements and an insatiable human curiosity to explore the vastness of space. The future promises even more exciting discoveries and a deeper understanding of our place in the universe. \n"
                  }
                ]
              },
              {
                "role": "user",
                "parts": [
                  {"text": "Explain the life outside milkyway"}
                ]
              }
            ],
            "generationConfig": {
              "temperature": 1,
              "topK": 64,
              "topP": 0.95,
              "maxOutputTokens": 8192,
              "responseMimeType": "text/plain"
            },
            "safetySettings": [
              {
                "category": "HARM_CATEGORY_HARASSMENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_HATE_SPEECH",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              }
            ]
          });
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response
            .data['candidates'].first['content']['parts'].first['text'];
      }

      return '';
    } catch (e) {
      log(e.toString() as num);
      return '';
    }
  }
}
