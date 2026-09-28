import UIKit

struct OriginDataProvider {
    static func getOrigins() -> [RestaurantOrigin] {
        return [
            // 1. Wing Snob (10 Slides)
            RestaurantOrigin(
                restaurantId: "1",
                restaurantName: "Wing Snob",
                themeColor: UIColor(red: 0.99, green: 0.80, blue: 0.28, alpha: 1.0),
                tagline: "The Saucy Revolution",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: The Midnight Craving",
                        subtitle: "Detroit, Michigan — 2017",
                        storyText: "Two wing enthusiasts were sitting in a garage, tired of dry, mediocre chicken. They made a pact: 'We will make wings a craft art form.'",
                        imageName: "flame.fill",
                        menuHighlight: "🔥 The Spark of Innovation"
                    ),
                    OriginSlide(
                        title: "Chapter 2: The Secret Dry Rubs",
                        subtitle: "The First Experiments",
                        storyText: "They tested over 50 spice blends until they hit the perfect balance of garlic, paprika, and brown sugar crunch.",
                        imageName: "leaf.fill",
                        menuHighlight: "✨ Garlic Parmesan & Cajun Rub"
                    ),
                    OriginSlide(
                        title: "Chapter 3: The Snob Philosophy",
                        subtitle: "Never Frozen, Always Fresh",
                        storyText: "Why call it Wing Snob? Because they strictly refuse frozen wings! Freshness became their main rule.",
                        imageName: "snowflake.slash",
                        menuHighlight: "🍗 100% Fresh Traditional Wings"
                    ),
                    OriginSlide(
                        title: "Chapter 4: The Sauce Explosion",
                        subtitle: "Crafting 15+ Flavors",
                        storyText: "From Honey BBQ to Mango Habanero, every sauce was perfected in small batches to coat every bite evenly.",
                        imageName: "drop.fill",
                        menuHighlight: "🍯 Sweet Chili Lou & Snob Sauce"
                    ),
                    OriginSlide(
                        title: "Chapter 5: Boneless Revolution",
                        subtitle: "Tender, Juicy Bites",
                        storyText: "Purists scoffed at boneless chicken, but Wing Snob created hand-breaded tenders so tender they won everyone over.",
                        imageName: "star.fill",
                        menuHighlight: "🍗 Hand-Breaded Boneless Tenders"
                    ),
                    OriginSlide(
                        title: "Chapter 6: Loaded Fry Mania",
                        subtitle: "The Ultimate Side Kick",
                        storyText: "Fries weren't enough. They created Loaded Snob Fries: crispy fries smothered in cheese, chopped chicken, and signature sauce.",
                        imageName: "square.stack.3d.up.fill",
                        menuHighlight: "🍟 Loaded Snob Fries"
                    ),
                    OriginSlide(
                        title: "Chapter 7: The Hot Buffalo Revival",
                        subtitle: "Classic Heat Done Right",
                        storyText: "Bringing back the authentic 90s Buffalo vibe with real butter, aged cayenne, and a tangy vinegar punch.",
                        imageName: "bolt.fill",
                        menuHighlight: "🌶️ Hot Buffalo Wings"
                    ),
                    OriginSlide(
                        title: "Chapter 8: The Expansion Era",
                        subtitle: "From One Shop to Midwest Icon",
                        storyText: "Lines started forming around the block. Word of mouth spread faster than the heat of their sauces!",
                        imageName: "map.fill",
                        menuHighlight: "📍 Midwest Wings Movement"
                    ),
                    OriginSlide(
                        title: "Chapter 9: The Community Vibe",
                        subtitle: "More Than Food",
                        storyText: "Wing Snob created a hangout spot with neon lights, urban art, and great music for wing lovers of all ages.",
                        imageName: "heart.fill",
                        menuHighlight: "🎶 Good Food & Great Energy"
                    ),
                    OriginSlide(
                        title: "Chapter 10: The Legacy Continues",
                        subtitle: "Your Flavor Journey",
                        storyText: "Today, Wing Snob continues to innovate new seasonal sauces and bring ultimate crunch to every plate.",
                        imageName: "crown.fill",
                        menuHighlight: "🏆 Master of Wing Flavors"
                    )
                ]
            ),

            // 2. Anthony's Coal Fired Pizza (10 Slides)
            RestaurantOrigin(
                restaurantId: "2",
                restaurantName: "Anthony's Coal Fired",
                themeColor: UIColor(red: 0.90, green: 0.80, blue: 0.95, alpha: 1.0),
                tagline: "Born from 900° Flames",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: The Missing Slice",
                        subtitle: "Florida — 2002",
                        storyText: "Anthony Bruno moved to Florida and missed authentic New York crispy pizza. He decided to build his own oven.",
                        imageName: "fireplace.fill",
                        menuHighlight: "🍕 The Search for Authentic Crust"
                    ),
                    OriginSlide(
                        title: "Chapter 2: The 900° Coal Oven",
                        subtitle: "Extreme Heat Secret",
                        storyText: "Anthracite coal burns hotter and cleaner than wood. At 900 degrees, a pizza cooks in under 4 minutes!",
                        imageName: "flame.circle.fill",
                        menuHighlight: "🔥 900° Coal Fired Magic"
                    ),
                    OriginSlide(
                        title: "Chapter 3: The Well-Done Char",
                        subtitle: "Don't Call It Burnt!",
                        storyText: "The dark, bubbly blisters on the crust aren't burnt — it's caramelized dough unlocking deep smoky flavor.",
                        imageName: "sparkles",
                        menuHighlight: "🖤 Signature Charred Crust"
                    ),
                    OriginSlide(
                        title: "Chapter 4: Jumbo Coal Roasted Wings",
                        subtitle: "The Unlikely Hit",
                        storyText: "Instead of deep frying, Anthony roasted jumbo wings in coal heat with caramelized onions and rosemary.",
                        imageName: "rosette",
                        menuHighlight: "🍗 Coal Roasted Wings & Onions"
                    ),
                    OriginSlide(
                        title: "Chapter 5: San Marzano Tomatoes",
                        subtitle: "Purity in Every Bite",
                        storyText: "Only plum tomatoes imported from Italy, crushed by hand with fresh basil and Italian olive oil.",
                        imageName: "leaf.circle.fill",
                        menuHighlight: "🍅 Authentic Italian Plum Sauce"
                    ),
                    OriginSlide(
                        title: "Chapter 6: Dan Marino Joins",
                        subtitle: "NFL Legend Partnership",
                        storyText: "Football hall-of-famer Dan Marino ate here once, fell in love with the food, and became a partner!",
                        imageName: "sportscourt.fill",
                        menuHighlight: "🏈 Marino's Choice Pizza"
                    ),
                    OriginSlide(
                        title: "Chapter 7: Eggplant Marino",
                        subtitle: "Thin & Delicate",
                        storyText: "Thinly sliced eggplant, lightly breaded, layered with fresh tomato sauce and grated Romano cheese.",
                        imageName: "tray.fill",
                        menuHighlight: "🍆 Legendary Eggplant Marino"
                    ),
                    OriginSlide(
                        title: "Chapter 8: Homemade Meatballs",
                        subtitle: "Grandma's Recipe",
                        storyText: "Hand-rolled daily using 100% beef, fresh herbs, and simmered slowly in rich marinara sauce.",
                        imageName: "circle.grid.cross.fill",
                        menuHighlight: "🧆 Coal Oven Meatballs"
                    ),
                    OriginSlide(
                        title: "Chapter 9: The Family Table",
                        subtitle: "Shared Dining Experience",
                        storyText: "Every meal is served family-style on large pans, bringing people together around hot coal ovens.",
                        imageName: "person.3.fill",
                        menuHighlight: "👨‍👩‍👧‍👦 Family Style Italian Feasts"
                    ),
                    OriginSlide(
                        title: "Chapter 10: Coal Fired Perfection",
                        subtitle: "The Tradition Lives On",
                        storyText: "From Florida to the East Coast, Anthony's keeps the coal fires burning hot for pizza lovers.",
                        imageName: "trophy.fill",
                        menuHighlight: "🍕 20% Off Takeout Tuesdays"
                    )
                ]
            ),

            // 3. Dewey's Pizza (10 Slides)
            RestaurantOrigin(
                restaurantId: "3",
                restaurantName: "Dewey's Pizza",
                themeColor: UIColor(red: 0.72, green: 0.78, blue: 0.96, alpha: 1.0),
                tagline: "The Art of the Dough Toss",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: The Glass Kitchen",
                        subtitle: "Cincinnati — 1998",
                        storyText: "Dewey's started with a radical idea: remove kitchen walls so guests can watch dough spin in the air!",
                        imageName: "eye.fill",
                        menuHighlight: "👀 Open Kitchen Performance"
                    ),
                    OriginSlide(
                        title: "Chapter 2: The Dough Flight",
                        subtitle: "Gravity-Defying Spin",
                        storyText: "Tossing dough isn't just for show — spinning it in air creates an ultra-light, airy crust texture.",
                        imageName: "wind",
                        menuHighlight: "🌀 Hand-Tossed Craft Crust"
                    ),
                    OriginSlide(
                        title: "Chapter 3: The Tito Santana",
                        subtitle: "Seasonal Masterpiece",
                        storyText: "A legendary taco-inspired pizza with taco sauce, cheddar, seasoned beef, chips, and fresh salsa.",
                        imageName: "star.circle.fill",
                        menuHighlight: "🌮 The Seasonal Tito Santana"
                    ),
                    OriginSlide(
                        title: "Chapter 4: The Green Lantern",
                        subtitle: "Pesto Supreme",
                        storyText: "Loaded with basil pesto, mozzarella, minced garlic, spinach, red onion, and artichoke hearts.",
                        imageName: "leaf.fill",
                        menuHighlight: "🥦 The Green Lantern Pie"
                    ),
                    OriginSlide(
                        title: "Chapter 5: Craft Beer Pairing",
                        subtitle: "Local Brews & Slices",
                        storyText: "Dewey's partnered with local craft breweries to pair every custom pizza with the perfect IPA or Stout.",
                        imageName: "mug.fill",
                        menuHighlight: "🍺 Local Craft Beer Selection"
                    ),
                    OriginSlide(
                        title: "Chapter 6: Build-Your-Own Calzone",
                        subtitle: "Pocket of Goodness",
                        storyText: "Golden-baked dough stuffed with ricotta, mozzarella, and your choice of gourmet toppings inside.",
                        imageName: "envelope.fill",
                        menuHighlight: "🥟 Overstuffed Craft Calzones"
                    ),
                    OriginSlide(
                        title: "Chapter 7: Fresh Gourmet Salads",
                        subtitle: "Not Just An Afterthought",
                        storyText: "Housemade dressings and candied walnuts make Dewey's salads famous in their own right.",
                        imageName: "carrot.fill",
                        menuHighlight: "🥗 Peppercorn Ranch & Candied Walnut"
                    ),
                    OriginSlide(
                        title: "Chapter 8: The Sound of Fun",
                        subtitle: "Rock & Roll Kitchens",
                        storyText: "Upbeat rock music and energetic pizza artists make every visit feel like a backyard party.",
                        imageName: "music.note",
                        menuHighlight: "🎸 Rock & Roll Pizza Vibes"
                    ),
                    OriginSlide(
                        title: "Chapter 9: Community First",
                        subtitle: "School & Charity Nights",
                        storyText: "Dewey's donates thousands of pizzas annually to local schools and neighborhood community events.",
                        imageName: "hands.sparkles.fill",
                        menuHighlight: "🤝 DewMore Charity Initiative"
                    ),
                    OriginSlide(
                        title: "Chapter 10: Craft Pizza Mastery",
                        subtitle: "Always Tossed Fresh",
                        storyText: "25+ years later, the dough keeps flying high and the ovens keep baking craft perfection.",
                        imageName: "crown.fill",
                        menuHighlight: "🍕 The Craft Pizza Experience"
                    )
                ]
            ),

            // 4. Dion's (10 Slides)
            RestaurantOrigin(
                restaurantId: "4",
                restaurantName: "Dion's",
                themeColor: UIColor(red: 0.68, green: 0.85, blue: 0.70, alpha: 1.0),
                tagline: "The Southwest Legend",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: The Accidental Pizzeria",
                        subtitle: "Albuquerque — 1978",
                        storyText: "Two Greek friends bought a small shop intended for Greek food, but realized locals wanted pizza!",
                        imageName: "building.2.fill",
                        menuHighlight: "🍕 From Greek to Pizza Legend"
                    ),
                    OriginSlide(
                        title: "Chapter 2: The Green Chile Revolution",
                        subtitle: "New Mexico Flavor",
                        storyText: "They added roasted hatch green chile to their pizzas, creating an instant Southwestern classic.",
                        imageName: "sun.max.fill",
                        menuHighlight: "🌶️ Hatch Green Chile Topping"
                    ),
                    OriginSlide(
                        title: "Chapter 3: The Famous Ranch",
                        subtitle: "Liquid Gold",
                        storyText: "Dion's housemade Ranch dressing became so popular that people started dipping everything in it!",
                        imageName: "drop.circle.fill",
                        menuHighlight: "🥛 Legendary Dion's Ranch"
                    ),
                    OriginSlide(
                        title: "Chapter 4: The Sub Sandwich Craze",
                        subtitle: "Fresh Baked Baguettes",
                        storyText: "Overstuffed subs served on warm, fresh-baked bread with premium meats and melted cheese.",
                        imageName: "line.horizontal.3.decrease.circle.fill",
                        menuHighlight: "🥪 Turkey & Green Chile Sub"
                    ),
                    OriginSlide(
                        title: "Chapter 5: The Stand-Up Counter",
                        subtitle: "Fast & Friendly",
                        storyText: "Dion's mastered the art of lightning-fast customer service without compromising fresh quality.",
                        imageName: "timer",
                        menuHighlight: "⚡ Quick & Fresh Service"
                    ),
                    OriginSlide(
                        title: "Chapter 6: The Kids' Dough Balls",
                        subtitle: "Family Fun Tradition",
                        storyText: "Every kid visiting Dion's gets a piece of raw dough to play with while waiting for food!",
                        imageName: "face.smiling.fill",
                        menuHighlight: "👶 Free Play Dough for Kids"
                    ),
                    OriginSlide(
                        title: "Chapter 7: The Dion's Special",
                        subtitle: "The Ultimate Combo",
                        storyText: "Loaded with pepperoni, mushrooms, green peppers, black olives, red onions, and Italian sausage.",
                        imageName: "checkmark.seal.fill",
                        menuHighlight: "⭐ The Dion's Special Pie"
                    ),
                    OriginSlide(
                        title: "Chapter 8: Bottled Ranch Magic",
                        subtitle: "Take It Home",
                        storyText: "By popular demand, Dion's began bottling their Ranch and Greek dressings for grocery shelves.",
                        imageName: "takeoutbag.and.cup.and.straw.fill",
                        menuHighlight: "🍾 Bottled Dressings To-Go"
                    ),
                    OriginSlide(
                        title: "Chapter 9: The Southwest Icon",
                        subtitle: "New Mexico Pride",
                        storyText: "Dion's became a staple symbol of Southwestern hospitality and community gatherings.",
                        imageName: "heart.text.square.fill",
                        menuHighlight: "🌵 100% Southwest Hospitality"
                    ),
                    OriginSlide(
                        title: "Chapter 10: Handcrafted Everyday",
                        subtitle: "Four Decades of Taste",
                        storyText: "Still hand-making dough, grating cheese, and roasting chiles fresh every single morning.",
                        imageName: "rosette",
                        menuHighlight: "🍕 Hand-Made Daily Since 1978"
                    )
                ]
            ),

            // 5. Marco's Pizza (10 Slides)
            RestaurantOrigin(
                restaurantId: "5",
                restaurantName: "Marco's Pizza",
                themeColor: UIColor(red: 0.96, green: 0.74, blue: 0.72, alpha: 1.0),
                tagline: "Authentic Italian Roots",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: From Italy to Ohio",
                        subtitle: "Toledo, Ohio — 1978",
                        storyText: "Pat Giammarco grew up in Italy making fresh sauce with his family before moving to America.",
                        imageName: "airplane",
                        menuHighlight: "🇮🇹 Italian Family Heritage"
                    ),
                    OriginSlide(
                        title: "Chapter 2: The 3-Cheese Blend",
                        subtitle: "The Dairy Secret",
                        storyText: "Pat crafted a signature blend of fresh mozzarella, white cheddar, and aged provolone.",
                        imageName: "square.grid.2x2.fill",
                        menuHighlight: "🧀 Signature 3-Cheese Blend"
                    ),
                    OriginSlide(
                        title: "Chapter 3: Daily Fresh Dough",
                        subtitle: "Never Chemical Treated",
                        storyText: "Made fresh in every store daily using spring wheat flour and filtered water.",
                        imageName: "circle.circle.fill",
                        menuHighlight: "🍞 Fresh Daily Dough"
                    ),
                    OriginSlide(
                        title: "Chapter 4: The Pepperoni Magnifico",
                        subtitle: "Double Pepperoni Delight",
                        storyText: "Topped with classic pepperoni AND crispy cupped Old World Pepperoni that holds savory oil.",
                        imageName: "flame.fill",
                        menuHighlight: "🍕 Pepperoni Magnifico"
                    ),
                    OriginSlide(
                        title: "Chapter 5: Crust Toppers",
                        subtitle: "Free Flavor Boost",
                        storyText: "Garlic Butter, Roma Herb, or Parmesan Cheese crust toppers added free to any pizza!",
                        imageName: "star.fill",
                        menuHighlight: "✨ Free Flavor Crust Toppers"
                    ),
                    OriginSlide(
                        title: "Chapter 6: Pizza Bowls",
                        subtitle: "Crustless Innovation",
                        storyText: "All the delicious toppings, sauce, and cheese baked in a bowl without the carb crust.",
                        imageName: "tray.2.fill",
                        menuHighlight: "🥣 Crustless Specialty Pizza Bowls"
                    ),
                    OriginSlide(
                        title: "Chapter 7: Cheesy Bread Magic",
                        subtitle: "The Ultimate Starter",
                        storyText: "Fresh dough baked with signature cheese blend and served with warm marinate sauce.",
                        imageName: "square.fill",
                        menuHighlight: "🥖 Cheesybread & Sauce"
                    ),
                    OriginSlide(
                        title: "Chapter 8: The Italian Sub",
                        subtitle: "Toasted Perfection",
                        storyText: "Salami, ham, provolone, banana peppers, and Italian dressing toasted golden hot.",
                        imageName: "list.bullet.rectangle.fill",
                        menuHighlight: "🥪 Toasted Italian Sub"
                    ),
                    OriginSlide(
                        title: "Chapter 9: The Primo Specialty",
                        subtitle: "Gourmet Combinations",
                        storyText: "White Cheesy, All-Meat, and Garden Specialty pizzas made Marco's a household favorite.",
                        imageName: "crown.fill",
                        menuHighlight: "👑 Primo Specialty Line"
                    ),
                    OriginSlide(
                        title: "Chapter 10: The Italian Way",
                        subtitle: "Quality You Can Taste",
                        storyText: "Marco's continues to grow nationwide while sticking strictly to Pat's Italian roots.",
                        imageName: "heart.fill",
                        menuHighlight: "🇮🇹 Authentic Italian Flavor"
                    )
                ]
            ),

            // 6. Dave's Hot Chicken (10 Slides)
            RestaurantOrigin(
                restaurantId: "6",
                restaurantName: "Dave's Hot Chicken",
                themeColor: UIColor(red: 0.98, green: 0.68, blue: 0.52, alpha: 1.0),
                tagline: "From Parking Lot to Empire",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: The $900 Parking Lot",
                        subtitle: "East Hollywood — 2017",
                        storyText: "Four friends scraped together $900 to set up a tiny chicken stand in a parking lot with portable fryers.",
                        imageName: "car.fill",
                        menuHighlight: "🚗 The Hollywood Parking Lot Stand"
                    ),
                    OriginSlide(
                        title: "Chapter 2: The Nashville Spice",
                        subtitle: "Hot Pepper Obsession",
                        storyText: "Dave Kopushyan trained in Michelin-star restaurants before creating his secret cayenne spice blend.",
                        imageName: "flame.fill",
                        menuHighlight: "🌶️ Secret Spice Recipe"
                    ),
                    OriginSlide(
                        title: "Chapter 3: The 7 Spice Levels",
                        subtitle: "From Mild to Reaper",
                        storyText: "Offering 7 levels of heat: No Spice, Lite Mild, Mild, Medium, Hot, Extra Hot, and Carolina Reaper!",
                        imageName: "chart.bar.fill",
                        menuHighlight: "🔥 7 Levels of Spice"
                    ),
                    OriginSlide(
                        title: "Chapter 4: The Reaper Waiver",
                        subtitle: "Extreme Heat Warning",
                        storyText: "The Reaper slider is so ridiculously hot that guests have to sign a liability waiver before eating!",
                        imageName: "doc.text.fill",
                        menuHighlight: "⚠️ Signed Reaper Waiver"
                    ),
                    OriginSlide(
                        title: "Chapter 5: Viral Instagram Craze",
                        subtitle: "Food Blogger Blowup",
                        storyText: "A popular food blogger posted a photo of juicy tender sliders. The next day, lines stretched blocks long!",
                        imageName: "camera.fill",
                        menuHighlight: "📸 Viral Instagram Fame"
                    ),
                    OriginSlide(
                        title: "Chapter 6: Drake Joins the Team",
                        subtitle: "Global Superstar Backing",
                        storyText: "Music icon Drake tasted the chicken, loved it, and became one of the primary investors!",
                        imageName: "music.mic",
                        menuHighlight: "🎤 Drake's Favorite Chicken"
                    ),
                    OriginSlide(
                        title: "Chapter 7: Kale Slaw & Sauce",
                        subtitle: "The Perfect Balance",
                        storyText: "Cool kale slaw, pickles, and creamy Dave's Sauce balance out the fiery hot chicken tenders.",
                        imageName: "line.3.crossed.swords",
                        menuHighlight: "🥗 House Kale Slaw & Dave's Sauce"
                    ),
                    OriginSlide(
                        title: "Chapter 8: The Big Trio",
                        subtitle: "The Ultimate Combo",
                        storyText: "3 jumbo tenders, fries, kale slaw, pickles, drizzled with honey and signature sauce.",
                        imageName: "square.grid.3x3.topleft.filled",
                        menuHighlight: "🍗 The Big Trio Combo"
                    ),
                    OriginSlide(
                        title: "Chapter 9: Street Art Aesthetics",
                        subtitle: "Urban Vibe",
                        storyText: "Every store features custom street art murals created by local graffiti artists.",
                        imageName: "paintpalette.fill",
                        menuHighlight: "🎨 Custom Street Art Murals"
                    ),
                    OriginSlide(
                        title: "Chapter 10: The Fastest Growing Chain",
                        subtitle: "Global Heat Takeover",
                        storyText: "From a $900 street pop-up to hundreds of locations worldwide. Feel the heat!",
                        imageName: "trophy.fill",
                        menuHighlight: "🔥 Blow Your Mind Hot Chicken"
                    )
                ]
            ),

            // 7. Jet's Pizza (10 Slides)
            RestaurantOrigin(
                restaurantId: "7",
                restaurantName: "Jet's Pizza",
                themeColor: UIColor(red: 0.99, green: 0.85, blue: 0.62, alpha: 1.0),
                tagline: "Better, Crispier, Square",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: The Vacant Party Store",
                        subtitle: "Sterling Heights, MI — 1978",
                        storyText: "Eugene Jetts bought a vacant building instead of a home, turning it into Jet's Detroit-Style Pizza shop.",
                        imageName: "house.fill",
                        menuHighlight: "🏬 The Original 1978 Store"
                    ),
                    OriginSlide(
                        title: "Chapter 2: The Steel Pan Magic",
                        subtitle: "Detroit Deep Dish Legend",
                        storyText: "Baked in heavy automotive steel pans that fry the edges of dough to caramelized crunch perfection.",
                        imageName: "square.fill",
                        menuHighlight: "🏎️ Automotive Steel Pan Crust"
                    ),
                    OriginSlide(
                        title: "Chapter 3: The Crunchy Corners",
                        subtitle: "Everyone's Favorite Slice",
                        storyText: "The corner slices have double the crunchy cheese crust. People literally fight for the corners!",
                        imageName: "viewfinder",
                        menuHighlight: "📐 Deep Dish Crunchy Corners"
                    ),
                    OriginSlide(
                        title: "Chapter 4: Turbo Crust Flavor",
                        subtitle: "Garlic, Butter & Romano",
                        storyText: "Jet's invented Turbo Crust: brushing the square crust edges with butter, garlic, and Romano cheese.",
                        imageName: "bolt.fill",
                        menuHighlight: "✨ Famous Turbo Crust"
                    ),
                    OriginSlide(
                        title: "Chapter 5: Cajun Ranch Flavor",
                        subtitle: "Zesty & Spicy Dip",
                        storyText: "Pairing deep dish pizza with Jet's housemade Cajun Ranch created a cult-like fan following.",
                        imageName: "drop.fill",
                        menuHighlight: "🌶️ New Cajun Ranch Dip"
                    ),
                    OriginSlide(
                        title: "Chapter 6: Jetboats & Wings",
                        subtitle: "Beyond Square Pizza",
                        storyText: "Freshly baked dough folded over cheese, toppings, and brushed with butter — the Jetboat was born!",
                        imageName: "ferry.fill",
                        menuHighlight: "🚤 Signature Jetboats"
                    ),
                    OriginSlide(
                        title: "Chapter 7: Hand-Cut Veggies Daily",
                        subtitle: "Zero Shortcuts",
                        storyText: "Onions, green peppers, and tomatoes chopped fresh every morning for crisp flavor in every bite.",
                        imageName: "scissors",
                        menuHighlight: "🧅 Daily Fresh Cut Veggies"
                    ),
                    OriginSlide(
                        title: "Chapter 8: The 8-Piece Deep Dish",
                        subtitle: "Feast For The Crew",
                        storyText: "Heavy, thick, and satisfying. One slice feels like two slices of traditional thin crust!",
                        imageName: "number.8.square.fill",
                        menuHighlight: "🍕 8-Piece Deep Dish Square"
                    ),
                    OriginSlide(
                        title: "Chapter 9: Text-to-Order AI",
                        subtitle: "Pioneer in Tech",
                        storyText: "Jet's became the first pizza chain to allow ordering via simple SMS text message AI!",
                        imageName: "message.fill",
                        menuHighlight: "📱 Text-to-Order Innovation"
                    ),
                    OriginSlide(
                        title: "Chapter 10: Life Is Short. Eat Better Pizza.",
                        subtitle: "The Detroit Legacy",
                        storyText: "Four decades later, Jet's remains the gold standard for crunchy Detroit-Style square pizza.",
                        imageName: "crown.fill",
                        menuHighlight: "🏆 Detroit-Style Pizza King"
                    )
                ]
            ),

            // 8. Giordano's (10 Slides)
            RestaurantOrigin(
                restaurantId: "8",
                restaurantName: "Giordano's",
                themeColor: UIColor(red: 0.75, green: 0.86, blue: 0.72, alpha: 1.0),
                tagline: "The Deep Dish Royalty",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: Mama's Easter Pie",
                        subtitle: "Torino, Italy — 1800s",
                        storyText: "Mama Giordano was famous in her Italian town for baking stuffed double-crusted double-cheese pies for holidays.",
                        imageName: "heart.fill",
                        menuHighlight: "🇮🇹 Italian Family Stuffed Recipe"
                    ),
                    OriginSlide(
                        title: "Chapter 2: The Chicago Dream",
                        subtitle: "Chicago, Illinois — 1974",
                        storyText: "Brothers Efren and Joseph moved to Chicago and introduced their mother's stuffed deep dish recipe.",
                        imageName: "building.columns.fill",
                        menuHighlight: "🏙️ The Chicago Deep Dish Debut"
                    ),
                    OriginSlide(
                        title: "Chapter 3: Double Layer Crust",
                        subtitle: "Stuffed Pizza Architecture",
                        storyText: "Bottom crust, pounds of Wisconsin cheese, fillings, a SECOND thin crust layer, topped with rich tomato sauce!",
                        imageName: "layers.fill",
                        menuHighlight: "🥧 Stuffed Double-Crust Build"
                    ),
                    OriginSlide(
                        title: "Chapter 4: The 6-Inch Cheese Pull",
                        subtitle: "Instagram Famous Pull",
                        storyText: "Lifting a single slice creates an epic, endless ribbon of molten Wisconsin mozzarella cheese.",
                        imageName: "arrow.up.and.down.square.fill",
                        menuHighlight: "🧀 Iconic Epic Cheese Pull"
                    ),
                    OriginSlide(
                        title: "Chapter 5: Slow Baked Patience",
                        subtitle: "45 Minutes of Love",
                        storyText: "A real Giordano's stuffed pie takes 45 minutes to bake thoroughly in deep round pans. Worth every second!",
                        imageName: "clock.fill",
                        menuHighlight: "⏳ 45-Minute Slow Bake Perfection"
                    ),
                    OriginSlide(
                        title: "Chapter 6: Wisconsin Mozzarella",
                        subtitle: "Custom Dairy Craft",
                        storyText: "Specially produced for Giordano's by small Wisconsin dairy farms to ensure perfect melt elasticity.",
                        imageName: "leaf.circle.fill",
                        menuHighlight: "🐄 Premium Wisconsin Mozzarella"
                    ),
                    OriginSlide(
                        title: "Chapter 7: Chicago Classic Combo",
                        subtitle: "Sausage, Peppers & Mushrooms",
                        storyText: "Packed with savory Italian sausage, fresh mushrooms, onions, and green peppers inside stuffed layers.",
                        imageName: "star.fill",
                        menuHighlight: "🍕 The Chicago Classic Stuffed Pie"
                    ),
                    OriginSlide(
                        title: "Chapter 8: Tavern-Style Thin Crust",
                        subtitle: "Chicago's Secret Slice",
                        storyText: "For quick lunches, Giordano's offers crispy thin tavern-style pizza cut into bite-sized squares.",
                        imageName: "square.grid.3x3.fill",
                        menuHighlight: "✂️ Square-Cut Tavern Style"
                    ),
                    OriginSlide(
                        title: "Chapter 9: Nationwide Shipping",
                        subtitle: "Dry Ice Pies",
                        storyText: "Fans across America can order frozen Giordano's stuffed pies shipped directly to their doorstep!",
                        imageName: "shippingbox.fill",
                        menuHighlight: "📦 Frozen Pies Shipped Nationwide"
                    ),
                    OriginSlide(
                        title: "Chapter 10: Official Chicago Legend",
                        subtitle: "Over 50 Years of Royalty",
                        storyText: "Voted #1 Deep Dish in Chicago by locals, tourists, and food critics alike. Long live the pie!",
                        imageName: "crown.fill",
                        menuHighlight: "👑 The Deep Dish Royalty"
                    )
                ]
            )
        ]
    }
}
