import UIKit

/// Единый большой массив вопросов. Просто добавляй новые строки через q(...).
/// Формат: q("Вопрос", ["A", "B", "C", "D"], индекс правильного)
enum QuestionBank {

    private static func q(_ text: String, _ options: [String], _ correct: Int) -> QuizQuestion {
        QuizQuestion(text: text, options: options, correctAnswerIndex: correct)
    }

    static let all: [QuizQuestion] = [
        // MARK: - Iconic Chain & Fast Food Lore
        q("In which American city was the first Wing Snob restaurant opened?", ["Detroit", "Chicago", "Atlanta", "Dallas"], 0),
        q("Which pizza chain is famous for baking its pizzas in rectangular steel pans originally made for auto parts?", ["Jet's Pizza", "Domino's", "Papa Johns", "Little Caesars"], 0),
        q("Where did Dave's Hot Chicken start as a simple street food pop-up stand?", ["Los Angeles", "Nashville", "Austin", "Miami"], 0),
        q("Which fast-food chain originally created the iconic 'Drive-Thru' concept?", ["Red's Giant Open-Air", "McDonald's", "Wendy's", "In-N-Out Burger"], 0),
        q("In which Asian country is it a huge Christmas tradition to eat KFC?", ["Japan", "South Korea", "China", "Thailand"], 0),
        q("Which iconic West Coast burger chain is famous for its unlisted 'Secret Menu'?", ["In-N-Out Burger", "Shake Shack", "Five Guys", "Whataburger"], 0),
        q("Which chain pioneered 30-minute pizza delivery before dropping the guarantee for safety reasons?", ["Domino's", "Pizza Hut", "Marco's Pizza", "Papa Johns"], 0),
        q("What famous coffee giant opened its very first store at Seattle's Pike Place Market?", ["Starbucks", "Dunkin'", "Peet's Coffee", "Tim Hortons"], 0),

        // MARK: - Origin Spots (Where Dishes Were Born)
        q("In which city and bar were the original Buffalo Wings invented in 1964?", ["Anchor Bar in Buffalo", "Pizzeria Uno in Chicago", "Tootsie's in Nashville", "Katz's in New York"], 0),
        q("Where was the world-famous Caesar Salad actually invented?", ["Tijuana, Mexico", "Rome, Italy", "New York, USA", "Nice, France"], 0),
        q("In which historic city was the original Pizza Margherita created in 1889?", ["Naples", "Rome", "Florence", "Milan"], 0),
        q("Where was the original Bellini cocktail created at the famous Harry's Bar?", ["Venice", "Florence", "Paris", "Monte Carlo"], 0),
        q("Which Singapore hotel bar invented the iconic Singapore Sling cocktail in 1915?", ["Raffles Hotel", "Marina Bay Sands", "The Fullerton", "Shangri-La"], 0),
        q("In which country was the very first Hawaiian Pizza (with pineapple) created?", ["Canada", "USA", "Italy", "Greece"], 0),

        // MARK: - Restaurant History & Guinness World Records
        q("According to Guinness World Records, what is the oldest continuously operating restaurant in the world?", ["Sobrino de Botín (Madrid)", "Fraunces Tavern (New York)", "St. Peter Stiftskulinarium (Salzburg)", "La Tour d'Argent (Paris)"], 0),
        q("Why did Michelin tires originally start publishing the Michelin Restaurant Guide?", ["To encourage road trips and sell more tires", "To review racing drivers' meals", "To rank French bakeries", "To train hotel chefs"], 0),
        q("What is the maximum number of Michelin stars a single restaurant can earn?", ["3", "5", "7", "10"], 0),
        q("Which city currently holds the world record for the highest total number of Michelin-starred restaurants?", ["Tokyo", "Paris", "Kyoto", "New York"], 0),
        q("Which legendary chef famously asked to return his 3 Michelin stars and retire from high cuisine in 1999?", ["Marco Pierre White", "Gordon Ramsay", "Alain Ducasse", "Paul Bocuse"], 0),

        // MARK: - Iconic Restaurants & Food Capitals
        q("Which famous Chicago pizzeria is credited with inventing the Deep-Dish Pizza in 1943?", ["Pizzeria Uno", "Giordano's", "Lou Malnati's", "Gino's East"], 0),
        q("Which iconic London department store is world-famous for its massive luxury Food Hall?", ["Harrods", "Selfridges", "Fortnum & Mason", "Harvey Nichols"], 0),
        q("Which U.S. city is famously known as the birthplace of the Po' Boy sandwich and Beignets?", ["New Orleans", "Memphis", "Charleston", "Savannah"], 0),
        q("Which famous historic fish market in Tokyo was world-renowned for its early morning tuna auctions?", ["Tsukiji", "Toyosu", "Kuromon", "Nishiki"], 0),
        q("In which European city was the famous Sachertorte chocolate cake invented?", ["Vienna", "Zurich", "Berlin", "Munich"], 0),

        // MARK: - Pop Culture & Food Trivia
        q("Which NYC diner became famous after being featured in the film 'When Harry Met Sally'?", ["Katz's Delicatessen", "Tom's Restaurant", "Junior's", "Eisenberg's"], 0),
        q("What is the name of the fictional fast-food chicken chain in 'Breaking Bad'?", ["Los Pollos Hermanos", "Cluckin' Bell", "Pollos Del Mar", "El Pollo Loco"], 0),
        q("What type of coffee shop is 'Central Perk' in the TV show Friends?", ["Fictional Manhattan café", "A real Starbucks location", "A diner in Brooklyn", "A bakery in Chicago"], 0),
        q("Which restaurant chain is famous in the U.S. for its intentionally rude service from staff?", ["Dick's Last Resort", "Hooters", "Hard Rock Cafe", "Rainforest Cafe"], 0),
        q("Which famous restaurant chain serves food on a track system using miniature roller coasters in some locations?", ["Rollercoaster Restaurant", "Space 220", "Medieval Times", "Hard Rock Cafe"], 0),
        q("Which city is known as the Curry Capital of the UK due to its density of Indian restaurants?", ["Bradford", "London", "Birmingham", "Manchester"], 0),
        
        // MARK: - Iconic Food Markets & Streets
                q("Which famous street market in Bangkok is legendary for its Michelin-starred street food stalls?", ["Jay Fai (Maha Chai Road)", "Jadd Fai Night Market", "Khao San Road", "Chatuchak"], 0),
                q("Which covered food market in Seattle is world-famous for fishmongers throwing fish to each other?", ["Pike Place Market", "Reading Terminal Market", "Faneuil Hall", "Time Out Market"], 0),
                q("Mercado de San Miguel is a famous historic food market located in which European capital?", ["Madrid", "Barcelona", "Lisbon", "Seville"], 0),
                q("Which iconic Istanbul market has been the center of spice trade in Turkey since the 17th century?", ["Egyptian Bazaar (Spice Bazaar)", "Grand Bazaar", "Arasta Bazaar", "Sahaflar Bazaar"], 0),
                q("La Boqueria is one of the most famous fresh food markets in the world, located on La Rambla in which city?", ["Barcelona", "Madrid", "Valencia", "Bilbao"], 0),

                // MARK: - Regional Food Capitals & Origins
                q("Which Italian region is globally recognized as the exclusive birthplace of authentic Balsamic Vinegar of Modena?", ["Emilia-Romagna", "Tuscany", "Piedmont", "Veneto"], 0),
                q("Which region in southwestern France is world-famous for its production of Foie Gras and duck confit?", ["Gascony (Gascogne)", "Normandy", "Brittany", "Provence"], 0),
                q("Which Spanish city is universally celebrated as the official birthplace of authentic Paella?", ["Valencia", "Madrid", "Seville", "Granada"], 0),
                q("Which region in Japan is famous for producing authentic Wagyu beef certified under the A5 Kobe grade?", ["Hyogo Prefecture", "Hokkaido", "Okinawa", "Kyoto Prefecture"], 0),
                q("Which city in Penang state is widely considered the street food capital of Malaysia?", ["George Town", "Kuala Lumpur", "Ipoh", "Malacca"], 0),

                // MARK: - Culinary Landmarks & Unique Spots
                q("Where is the world-famous Under, Europe's largest underwater restaurant, located?", ["Norway", "Iceland", "Denmark", "Netherlands"], 0),
                q("In which European city can you find the historic Cafe Central, famous for its 19th-century coffeehouse culture?", ["Vienna", "Budapest", "Prague", "Zurich"], 0),
                q("Which historic city is famous for its 'Trabocchi' — wooden fishing platforms turned into seaside seafood restaurants?", ["Abruzzo, Italy", "Costa Brava, Spain", "Algarve, Portugal", "Dalmatia, Croatia"], 0),
                q("In which country will you find the iconic Ithaa Undersea Restaurant, set 5 meters below the Indian Ocean?", ["Maldives", "Seychelles", "Mauritius", "Fiji"], 0),
                q("Which European city is famous for its traditional 'Bouchons' — historic bistro-style restaurants serving local pork dishes?", ["Lyon", "Marseille", "Bordeaux", "Lille"], 0),

                // MARK: - Global Street Food Spots
                q("Which city's night markets, such as Shilin and Raohe, are world-famous for Stinky Tofu and Bubble Tea?", ["Taipei", "Hong Kong", "Singapore", "Seoul"], 0),
                q("In which Mexican state can you visit the street food capital known for 7 distinct varieties of Mole sauce?", ["Oaxaca", "Yucatán", "Jalisco", "Puebla"], 0),
                q("Which historic square in Marrakech transforms every evening into a massive open-air street food feast?", ["Jemaa el-Fnaa", "Rahba Kedima", "Place des Ferblantiers", "Bab Boujeloud"], 0),
                q("The famous street food dish 'Bun Cha' gained international fame after Anthony Bourdain and Barack Obama ate it together in which city?", ["Hanoi", "Ho Chi Minh City", "Da Nang", "Hue"], 0),
                q("Where would you find the famous Maxwell Food Centre, home to legendary Hainanese Chicken Rice stalls?", ["Singapore", "Kuala Lumpur", "Penang", "Hong Kong"], 0),

                // MARK: - Protected Geographical Destinations
                q("True Champagne can legally only be produced from grapes grown in which specific country and region?", ["Champagne region, France", "Catalonia, Spain", "Piedmont, Italy", "Bavaria, Germany"], 0),
                q("Which Greek island is world-famous for growing wild fava beans and tomatoes in unique volcanic ash soil?", ["Santorini", "Crete", "Mykonos", "Rhodes"], 0),
                q("Parmigiano-Reggiano cheese can legally only be produced in a designated zone in which country?", ["Italy", "France", "Switzerland", "Spain"], 0),
                q("Which Mexican town gives its name to the famous spirit made strictly from blue agave plants grown nearby?", ["Tequila", "Oaxaca", "Guadalajara", "Cancún"], 0),
                q("Which region in Portugal is world-famous for its terraced vineyards along the river where Port Wine is produced?", ["Douro Valley", "Alentejo", "Minho", "Dão"], 0),

                // MARK: - Iconic Food & Drink Routes
                q("Which French region is famous for its 170-kilometer 'Alsace Wine Route' lined with timber-framed villages?", ["Alsace", "Burgundy", "Bordeaux", "Loire Valley"], 0),
                q("In which US state can you drive the official 'Bourbon Trail', visiting historic whiskey distilleries?", ["Kentucky", "Tennessee", "Texas", "Virginia"], 0),
                q("Which city is world-renowned for its 'pintxos' bars crowded along the streets of its historic Old Town (Parte Vieja)?", ["San Sebastián", "Bilbao", "Pamplona", "Madrid"], 0),
                q("Which German city hosts the world's largest annual Volksfest and beer festival known as Oktoberfest?", ["Munich", "Berlin", "Frankfurt", "Stuttgart"], 0),
                q("Which South African valley, settled by French Huguenots, is known as the country's food and wine capital?", ["Franschhoek", "Stellenbosch", "Paarl", "Constantia"], 0),
        
        q("What is the highest award rating a single restaurant can receive in the Michelin Guide?", ["Three Stars", "Five Stars", "Four Stars", "Golden Spoon"], 0),
                q("What does a 1-Star rating in the Michelin Guide officially mean?", ["High-quality cooking, worth a stop", "Excellent cooking, worth a detour", "Exceptional cuisine, worth a special journey", "Best restaurant in the city"], 0),
                q("Which Michelin award recognizes restaurants that offer high-quality food at moderate prices?", ["Bib Gourmand", "Green Star", "Plate Michelin", "Michelin Select"], 0),
                q("What special Michelin rating was introduced in 2020 to reward sustainable and eco-friendly gastronomy?", ["Green Star", "Eco Spoon", "Earth Leaf", "Bio Clover"], 0),
                q("In which year was the very first Michelin Guide published in France?", ["1900", "1926", "1950", "1889"], 0),

                // MARK: - Legendary Chefs
                q("Which French chef held the record for the most total Michelin stars accumulated across his global empire (31 stars)?", ["Joël Robuchon", "Alain Ducasse", "Gordon Ramsay", "Paul Bocuse"], 0),
                q("Which famous British chef trained under Marco Pierre White and built a multi-starred restaurant empire?", ["Gordon Ramsay", "Jamie Oliver", "Heston Blumenthal", "Rick Stein"], 0),
                q("Who was widely celebrated as the 'Pope of French Gastronomy' and founded the prestigious Bocuse d'Or contest?", ["Paul Bocuse", "Auguste Escoffier", "Michel Guérard", "Daniel Boulud"], 0),
                q("Which French chef pioneered the modern brigade de cuisine system still used in professional kitchens today?", ["Auguste Escoffier", "Marie-Antoine Carême", "Joël Robuchon", "Raymond Blanc"], 0),
                q("Which chef famously became the youngest chef ever to earn 3 Michelin stars at age 33 in 1994?", ["Marco Pierre White", "Gordon Ramsay", "Alain Passard", "Thomas Keller"], 0),

                // MARK: - Iconic Fine Dining Restaurants
                q("Which Danish restaurant, led by chef René Redzepi, revolutionized New Nordic Cuisine and topped World's 50 Best lists?", ["Noma", "Geranium", "Frantzén", "Maaemo"], 0),
                q("Which legendary Spanish restaurant by Ferran Adrià is famous for inventing molecular gastronomy before closing in 2011?", ["El Bulli", "Arzak", "Mugaritz", "Disfrutar"], 0),
                q("The French Laundry, a iconic 3-star Michelin restaurant in Napa Valley, is helmed by which American chef?", ["Thomas Keller", "Grant Achatz", "Daniel Humm", "David Chang"], 0),
                q("Alinea, known for hyper-creative dishes like edible helium balloons, is located in which U.S. city?", ["Chicago", "New York", "San Francisco", "Los Angeles"], 0),
                q("Eleven Madison Park in NYC made history in 2021 by switching entirely to which type of menu?", ["100% Plant-based (Vegan)", "All-Seafood menu", "Gluten-free menu", "Carnivore tasting menu"], 0),

                // MARK: - Fine Dining Landmarks & Records
                q("Which luxury Tokyo restaurant held 3 Michelin stars for years while operating in a subway station basement?", ["Sukiyabashi Jiro", "Sushi Saito", "Ginza Kyubey", "Sushi Arai"], 0),
                q("Where in Europe can you find the historic Le Louis XV, Alain Ducasse's legendary 3-star restaurant inside a hotel?", ["Monaco (Monte Carlo)", "Paris", "Cannes", "Nice"], 0),
                q("Which Asian street food stall in Singapore famously became one of the cheapest Michelin-starred meals in the world?", ["Liao Fan Hong Kong Soya Sauce Chicken", "Hill Street Tai Hwa", "Tian Tian", "Hawker Chan"], 0),
                q("Which country outside of Europe received the first-ever dedicated Asian Michelin Guide in 2007?", ["Japan (Tokyo)", "China", "Singapore", "Thailand"], 0),
                q("Ultra Violet by Paul Pairet, an immersive multi-sensory 3-star restaurant with screens and scents, is in which city?", ["Shanghai", "Tokyo", "Hong Kong", "Singapore"], 0),

                // MARK: - Fine Dining Culture & Terminology
                q("What is the formal French culinary term for a pre-fixed multi-course meal highlighting the chef's signature dishes?", ["Tasting Menu (Menu Dégustation)", "A la carte", "Table d'hôte", "Amuse-bouche"], 0),
                q("What is the complimentary bite-sized item served before a fine dining meal called?", ["Amuse-bouche", "Hors d'oeuvre", "Entrée", "Digestif"], 0),
                q("Which term describes the top kitchen position responsible for overall menu design and culinary vision?", ["Executive Chef (Chef de Cuisine)", "Sous Chef", "Chef de Partie", "Maître d'hôtel"], 0),
                q("What specialized professional in a fine dining restaurant is dedicated exclusively to wine selection and pairing?", ["Sommelier", "Maître d'", "Barista", "Mixologist"], 0),
                q("In high-end dining, what does 'Table d'Hôte' traditionally refer to?", ["A set multi-course menu at a fixed price", "Ordering items individually", "Dining at the chef's personal counter", "Buffet-style service"], 0),

                // MARK: - Fine Dining Ingredients & Delicacies
                q("Which rare mushroom-like fungus, often called 'white gold', can cost thousands of dollars per kilogram in Alba, Italy?", ["White Truffle", "Morel", "Chanterelle", "Matsutake"], 0),
                q("Beluga, Osetra, and Sevruga are world-famous luxury varieties of which fine dining delicacy?", ["Caviar", "Foie Gras", "Saffron", "Wagyu"], 0),
                q("Which luxury French dish consists of fattened duck or goose liver served as a mousse or seared whole?", ["Foie Gras", "Escargot", "Sweetbreads", "Terrine"], 0),
                q("What high-end Japanese beef grading scale ranks meat based on marbling, color, and quality up to 'A5'?", ["JMGA (Japanese Meat Grading)", "USDA Prime", "BMS Scale", "Kobe Standard"], 0),
                q("Which delicate edible flower stigma spice is meticulously hand-harvested and considered the most expensive by weight?", ["Saffron", "Vanilla", "Cardamom", "Star Anise"], 0),
        
        q("In which NYC hotel is Eggs Benedict widely believed to have been created in 1894?", ["The Waldorf Astoria", "The Plaza", "The St. Regis", "The Drake"], 0),
                q("Where was the world's very first Hamburger created by Louis Lassen in 1900?", ["Louis' Lunch (New Haven)", "Nathan's Famous (NYC)", "Ray's Diner (Chicago)", "White Castle (Wichita)"], 0),
                q("Which legendary NYC restaurant invented the rich Delmonico Steak and Lobster Newberg?", ["Delmonico's", "Keens Steakhouse", "Peter Luger", "Gallaghers"], 0),
                q("Where was the original French Dip Sandwich invented using crusty rolls dipped in beef au jus?", ["Philippe the Original (Los Angeles)", "Katz's Delicatessen (NYC)", "Sardi's (NYC)", "Geno's Steaks (Philadelphia)"], 0),
                q("Which iconic Philadelphia shop claims to have invented the original Cheesesteak in 1930?", ["Pat's King of Steaks", "Geno's Steaks", "Jim's Steaks", "Tony Luke's"], 0),

                // MARK: - Classic Desserts & Sweets Origins
                q("In which historic hotel in Vienna was the world-famous Original Sacher-Torte chocolate cake created?", ["Hotel Sacher", "Hotel Imperial", "Grand Hotel Wien", "The Ritz Vienna"], 0),
                q("Which famous Parisian pastry shop claims to have invented the modern double-decker Macaron?", ["Ladurée", "Pierre Hermé", "Angelina", "Café de la Paix"], 0),
                q("Which Italian city is widely recognized as the official birthplace of Tiramisu in the 1960s?", ["Treviso", "Venice", "Florence", "Milan"], 0),
                q("Where was the decadent Peach Melba dessert invented by chef Auguste Escoffier?", ["Savoy Hotel (London)", "The Ritz (Paris)", "Hotel Carlton (Cannes)", "Claridge's (London)"], 0),
                q("In which city was the famous Tarte Tatin (upside-down apple tart) accidentally created by two sisters?", ["Lamotte-Beuvron, France", "Normandy, France", "Brussels, Belgium", "Geneva, Switzerland"], 0),

                // MARK: - World-Famous Cocktails & Drinks
                q("In which iconic bar in Venice was the Bellini cocktail invented by Giuseppe Cipriani?", ["Harry's Bar", "Caffè Florian", "Bar Longhi", "Gran Caffè Quadri"], 0),
                q("Which historic hotel in New Orleans gave birth to the famous Sazerac cocktail?", ["The Roosevelt Hotel (Sazerac Bar)", "The Monteleone", "The Pontchartrain", "Hotel Provincial"], 0),
                q("Where was the Piña Colada officially invented and declared the national drink in 1978?", ["Caribe Hilton (San Juan, Puerto Rico)", "Hotel Nacional (Havana, Cuba)", "El San Juan Hotel", "Condado Vanderbilt"], 0),
                q("In which famous Paris bar was the Bloody Mary cocktail created by bartender Fernand Petiot?", ["Harry's New York Bar", "The Hemingway Bar at The Ritz", "Bar du Le Bristol", "Le Select"], 0),
                q("Which city's Raffles Hotel famously invented the pink tropical Singapore Sling cocktail in 1915?", ["Singapore", "Kuala Lumpur", "Bangkok", "Hong Kong"], 0),

                // MARK: - International Food & Street Inventions
                q("Which Scottish butcher shop in London claims to have invented the portable Scotch Egg in 1738?", ["Fortnum & Mason", "Harrods", "Partridge's", "Lidgate's"], 0),
                q("In which German city was the iconic Currywurst street food dish invented by Herta Heuwer in 1949?", ["Berlin", "Hamburg", "Munich", "Cologne"], 0),
                q("Which Canadian city is the undisputed birthplace of Poutine (fries, cheese curds, and gravy)?", ["Centre-du-Québec region", "Montreal", "Ottawa", "Quebec City"], 0),
                q("Where was the world-famous Nachos snack originally created by Ignacio 'Nacho' Anaya in 1943?", ["Piedras Negras, Mexico", "Tijuana, Mexico", "El Paso, USA", "San Antonio, USA"], 0),
                q("Which Italian bakery or restaurant claims the original invention of the folded Calzone pizza?", ["Naples", "Rome", "Palermo", "Bari"], 0),

                // MARK: - Restaurant Chain Inventions
                q("Which fast-food giant invented the Filet-O-Fish in 1962 to cater to Catholic customers on Fridays?", ["McDonald's", "Burger King", "Wendy's", "Arby's"], 0),
                q("Which restaurant chain famously invented the stuffed crust pizza in 1995?", ["Pizza Hut", "Domino's", "Papa Johns", "Little Caesars"], 0),
                q("Where was the original Dave's Hot Chicken started inside a small parking lot setup?", ["East Hollywood, Los Angeles", "Nashville, Tennessee", "Austin, Texas", "Phoenix, Arizona"], 0),
                q("Which chain created the famous 'Blizzard' soft-serve treat that is served upside down?", ["Dairy Queen", "Sonic Drive-In", "Culver's", "Carvel"], 0),
                q("Which restaurant chain claims to have invented the original Boneless Wing for fast dining?", ["Buffalo Wild Wings", "Wing Snob", "Wingstop", "Zaxby's"], 0),

                // MARK: - Legendary Kitchen Discoveries
                q("In which American state was the Chocolate Chip Cookie invented at the Toll House Inn?", ["Massachusetts", "New York", "Pennsylvania", "Vermont"], 0),
                q("Where was Potato Chips famously invented after a customer complained about thick fried potatoes?", ["Moon's Lake House (Saratoga Springs, NY)", "Delmonico's (NYC)", "The Greenbrier (WV)", "The Drake (Chicago)"], 0),
                q("Which European country is the true birthplace of French Fries (despite the English name)?", ["Belgium", "France", "Switzerland", "Netherlands"], 0),
                q("In which country was the popular Chicken Tikka Masala created by South Asian chefs in the 1970s?", ["Scotland (Glasgow)", "India (Delhi)", "England (London)", "Pakistan (Lahore)"], 0),
                q("Where was the original Carpaccio (thinly sliced raw beef) invented and named after a Renaissance painter?", ["Harry's Bar (Venice)", "Ristorante Savini (Milan)", "Caffè Greco (Rome)", "Trattoria ZaZa (Florence)"], 0),
        
        // MARK: - Secret Menus & Custom Orders
                q("What does ordering a burger 'Animal Style' mean on In-N-Out's iconic secret menu?", ["Mustard-cooked patty with extra spread & grilled onions", "Triple patty with double bacon", "Wrapped in lettuce without a bun", "Topped with a fried egg and jalapeños"], 0),
                q("Which secret menu item can you order at Chipotle for a giant wrapped combination of a burrito inside a quesadilla?", ["The Quesarito", "The Burritzilla", "The Monster Wrap", "The El Jefe"], 0),
                q("What is the famous secret menu request at McDonald's that combines a Big Mac, McChicken, and Filet-O-Fish?", ["Land, Air & Sea Burger", "The Monster Mac", "The McGangBang", "The Titanic Stack"], 0),
                q("What popular Starbucks secret menu drink mimics the flavor of a famous campfire marshmallow treat?", ["S'mores Frappuccino", "Campfire Cold Brew", "Toasted Marshmallow Latte", "Fireside Mocha"], 0),
                q("Ordering a burger 'Protein Style' at In-N-Out replaces the traditional bun with what?", ["Lettuce leaves", "Grilled portobello mushrooms", "Extra cheese slices", "Crispy bacon strips"], 0),

                // MARK: - Quirky Traditions & Restaurant Rules
                q("In which country is it customary for KFC customers to order whole buckets of fried chicken months in advance for Christmas?", ["Japan", "South Korea", "Philippines", "China"], 0),
                q("At the famous Lambert's Cafe in Missouri, how are hot dinner rolls uniquely served to guests?", ["They are thrown across the dining room", "They are brought in a miniature train", "They are baked right at your table", "They are dropped from the ceiling"], 0),
                q("Which American diner chain is famous for staff who intentionally insult and mock their customers?", ["Dick's Last Resort", "Waffle House", "Ed Debevic's", "Heart Attack Grill"], 0),
                q("At Las Vegas' Heart Attack Grill, what happens to customers who weigh over 350 lbs (160 kg)?", ["They eat for free", "They get a free 2-liter soda", "They get a medal from the owner", "They win a free T-shirt"], 0),
                q("Which famous Chicago hot dog stand is notorious for strictly banning ketchup and berating customers who ask for it?", ["The Wiener's Circle", "Gene & Jude's", "Portillo's", "Superdawg"], 0),

                // MARK: - Weird Restaurant Concepts & Bizarre Lore
                q("In Taiwan, there is a famous chain of restaurants called 'Modern Toilet'. How is food served there?", ["In miniature toilet bowls and bidets", "On miniature shovel plates", "Inside hospital IV bags", "On trash can lids"], 0),
                q("Where is the famous 'Dinner in the Sky' experience, where guests eat strapped to chairs 150 feet up, originally from?", ["Belgium", "France", "Dubai", "United States"], 0),
                q("In Tokyo's 'Ninja Tokyo' restaurant, how do waiters present themselves to diners?", ["Dressed as stealth ninjas performing magic tricks", "Riding on unicycles", "Dressed as samurai warriors in full armor", "Communicating entirely through sign language"], 0),
                q("What is unique about the dining experience at the 'Dans le Noir?' restaurant chain?", ["Guests dine in absolute, complete darkness", "Guests must cook their own meals over lava rocks", "All waiters are dressed as ghosts", "Food is served entirely on tree bark"], 0),
                q("In Spain's Disaster Café, what simulated event happens to diners while they eat their meals?", ["A simulated 7.8 magnitude earthquake", "A fake volcanic eruption", "A sudden flash flood", "A fake blackout"], 0),

                // MARK: - Fast Food Secrets & Urban Legends
                q("Why do waffle lines on the grill exist at Waffle House, according to their secret server sign language?", ["To communicate order details to the cook without speaking", "To prevent waffles from sticking", "To measure cook temperature", "To speed up cleaning time"], 0),
                q("Which major fast-food chain's founder was buried in his signature white suit and bolo tie?", ["KFC (Colonel Sanders)", "Wendy's (Dave Thomas)", "McDonald's (Ray Kroc)", "Carl's Jr. (Carl Karcher)"], 0),
                q("What secret number code is printed on the bottom of every In-N-Out paper cup and wrapper?", ["Bible verse citations", "The year the store was built", "The employee's ID number", "The secret recipe ratio"], 0),
                q("What quirky guarantee did Domino's Pizza famously offer in the 1980s before cancelling it due to reckless driving?", ["Delivered in 30 minutes or it's free", "Free pizza if the box is crushed", "Delivered hot or double refund", "Free soda with every late delivery"], 0),
                q("Which fast-food chain has a secret VIP 'Gold Card' that gives celebrities like Bill Gates free food for life?", ["McDonald's", "Burger King", "Taco Bell", "Subway"], 0),

                // MARK: - Bizarre Food Laws & Restaurant Customs
                q("In Naples, Italy, what official organization inspects and certifies authentic Neapolitan pizzerias?", ["AVPN (Associazione Verace Pizza Napoletana)", "The Italian Pizza Guild", "Michelin Pizza Inspectorate", "The Crust Council"], 0),
                q("In Venice, Italy, what is illegal to do while sitting down to eat on public steps or bridges?", ["Eating street food or picnicking", "Drinking tap water", "Eating gelato after midnight", "Using disposable plastic forks"], 0),
                q("Which country famously banned chewing gum in 1992, making street sales of gum illegal?", ["Singapore", "Japan", "United Arab Emirates", "Switzerland"], 0),
                q("Why are authentic Parmigiano-Reggiano cheese wheels pin-pricked with small dots around the outer rind?", ["To display the official certified name and origin", "To let air escape during aging", "To mark the age in months", "To prevent counterfeiting with ink"], 0),
                q("In France, it is considered bad etiquette during a formal dinner to place your hands where?", ["Underneath the table in your lap", "On top of the table near the plate", "Resting on your knees", "Holding the wine glass by the bowl"], 0),

                // MARK: - Odd Restaurant Records & Trivia
                q("Which famous pizza chain holds the Guinness World Record for delivering a pizza to the highest altitude (on Mt. Kilimanjaro)?", ["Pizza Hut", "Domino's", "Papa Johns", "Little Caesars"], 0),
                q("What item is hidden inside traditional King Cakes served during Mardi Gras in New Orleans?", ["A tiny plastic baby", "A silver coin", "A golden ring", "A dried bean"], 0),
                q("Which fast-food chain once launched a space mission to send a bacon cheeseburger into the stratosphere on a balloon?", ["KFC", "Red Robin", "Burger King", "Carl's Jr."], 0),
                q("What is the secret reason why McDonald's McFlurry spoons have a hollow, square-shaped top?", ["It attaches directly to the machine to mix the McFlurry", "It acts as a straw for melted ice cream", "It keeps the spoon cool while holding", "It reduces plastic usage"], 0),
                q("At the Heart Attack Grill in Las Vegas, what do the waitresses wear as their uniforms?", ["Nurse outfits", "Police uniforms", "Chef coats", "Racecar driver suits"], 0),
        
        // MARK: - Iconic TV Show Eateries
                q("What is the name of the fictional Manhattan coffee shop where the main characters always gather in 'Friends'?", ["Central Perk", "Monk's Diner", "MacLaren's Pub", "Luke's Diner"], 0),
                q("Which fictional fast-food chicken chain serves as a front for Gus Fring's drug empire in 'Breaking Bad'?", ["Los Pollos Hermanos", "Cluckin' Bell", "Pollos Del Mar", "El Pollo Loco"], 0),
                q("What is the name of the iconic diner in 'Seinfeld' where Jerry, Elaine, George, and Kramer routinely hang out?", ["Monk's Diner", "Central Perk", "The Regal Beagle", "JJ's Diner"], 0),
                q("In 'How I Met Your Mother', what is the name of the Irish pub located below Marshall and Ted's apartment?", ["MacLaren's Pub", "Puzzles", "McGee's Pub", "O'Malley's"], 0),
                q("What is the name of Luke Danes' famous coffee and breakfast spot in 'Gilmore Girls'?", ["Luke's Diner", "Al's Pancake World", " Stars Hollow Cafe", "Dosie's Market"], 0),

                // MARK: - Animated Classics & Cartoons
                q("What is the name of the famous fast-food restaurant where SpongeBob SquarePants works as a fry cook?", ["The Krusty Krab", "The Chum Bucket", "The Salty Spitoon", "Weenie Hut Juniors"], 0),
                q("Where does Homer Simpson famously spend his evenings drinking Duff Beer in 'The Simpsons'?", ["Moe's Tavern", "The Rusty Barnacle", "Joe's Bar", "Springfield Pub"], 0),
                q("In 'Bob's Burgers', what type of food does Bob Belcher's family restaurant specialize in?", ["Gourmet Burgers", "Tacos & Burritos", "Pizza & Pasta", "Hot Dogs"], 0),
                q("What is the name of the fictional pizza delivery chain whose truck appears in almost every Pixar film?", ["Pizza Planet", "Planet Pepperoni", "Pizza Express", "Galactic Crust"], 0),
                q("In 'Family Guy', what is the name of the local Quahog tavern frequented by Peter Griffin and his friends?", ["The Drunken Clam", "The Salty Anchor", "The Blind Pig", "Quahog Pub"], 0),

                // MARK: - Iconic Movie Restaurants & Bars
                q("In Quentin Tarantino's 'Pulp Fiction', what is the name of the 1950s-themed restaurant where Vincent and Mia dance?", ["Jack Rabbit Slim's", "Big Kahuna Burger", "The Red Apple", "Monster Bash"], 0),
                q("What is the name of the Hawaiian-themed fast-food burger joint featured in 'Pulp Fiction' and 'Reservoir Dogs'?", ["Big Kahuna Burger", "Tiki Burger", "Aloha Bites", "Luau Grill"], 0),
                q("In 'The Grand Budapest Hotel', what is the name of the famous bakery known for its 'Courtesan au Chocolat' pastries?", ["Mendl's", "Herr Mendl", "Café Lutz", "Zubrowka Bakery"], 0),
                q("In 'Star Wars: A New Hope', on which planet is the famous Mos Eisley Cantina located?", ["Tatooine", "Coruscant", "Alderaan", "Naboo"], 0),
                q("Which real-life NYC diner became world-famous after the iconic 'I'll have what she's having' scene in 'When Harry Met Sally'?", ["Katz's Delicatessen", "Tom's Restaurant", "Serendipity 3", "21 Club"], 0),

                // MARK: - Sci-Fi, Cult & Fantasy Spots
                q("In 'The Hitchhiker's Guide to the Galaxy', what is the legendary restaurant situated at the end of time?", ["The Restaurant at the End of the Universe", "Milliways", "The Cosmic Cafe", "Eternity Diner"], 0),
                q("What is the name of the famous wizarding pub in Hogsmeade known for serving Butterbeer in 'Harry Potter'?", ["The Three Broomsticks", "The Leaky Cauldron", "The Hog's Head", "Flourish and Blotts"], 0),
                q("In 'Twin Peaks', what is the name of the iconic diner where Agent Cooper enjoys 'a damn fine cup of coffee' and cherry pie?", ["Double R Diner", "The Black Lodge", "Twisted Pine Diner", "Bookhouse Cafe"], 0),
                q("In the 'Marvel Cinematic Universe', what food do the Avengers go eat together in the iconic post-credits scene of 'The Avengers'?", ["Shawarma", "Cheeseburgers", "Tacos", "Pizza"], 0),
                q("In 'Goodfellas', what is the name of the real-life NYC nightclub where Henry Hill enters through the famous kitchen side-entrance?", ["Copacabana", "The Bamboo Lounge", "The Stork Club", "El Morocco"], 0),

                // MARK: - Cult Classic Fast-Food & Franchises
                q("What is the name of the fictional fast-food burger chain featured throughout the 'Grand Theft Auto' game series?", ["Cluckin' Bell", "Burger Shot", "Up-n-Atom", "Well-Stacked Pizza"], 0),
                q("In the film 'Coming to America', what is the name of the fast-food restaurant that parodies McDonald's?", ["McDowell's", "MacDonald's", "Golden Arches", "Big Mick's"], 0),
                q("In 'Harold & Kumar Go to...', which real-life fast-food slider chain are the main characters desperately trying to reach?", ["White Castle", "Krystal", "In-N-Out", "Checkers"], 0),
                q("In the 1993 sci-fi movie 'Demolition Man', which restaurant chain is the only one to survive the 'Franchise Wars'?", ["Taco Bell", "Pizza Hut", "McDonald's", "Burger King"], 0),
                q("In 'Wayne's World', which classic doughnut chain features heavily as the local hangout spot?", ["Stan Mikita's Donuts", "Dunkin' Donuts", "Tim Hortons", "Krispy Kreme"], 0),

                // MARK: - Real-Life Places Inspired by Screen Legends
                q("Which famous real-life restaurant chain was inspired by the movie 'Forrest Gump'?", ["Bubba Gump Shrimp Co.", "Lieutenant Dan's Seafood", "Greenbow Grill", "Run Forrest Run Cafe"], 0),
                q("The exterior of 'Tom's Restaurant' in New York City was used as the storefront for which TV show's diner?", ["Seinfeld", "Friends", "How I Met Your Mother", "Mad Men"], 0),
                q("Which real-life Italian-American restaurant in NYC served as a filming location for 'The Godfather' and 'The Sopranos'?", ["Bamonte's", "Rao's", "Il Mulino", "Carmine's"], 0),
                q("In 'Parks and Recreation', what is Leslie Knope's absolute favorite breakfast restaurant serving giant waffles?", ["JJ's Diner", "The Paunch Burger", "Sue's Salads", "Eagleton Cafe"], 0),
                q("In 'The Office' (US), what is the name of the local Scranton bar where the Dunder Mifflin staff frequently hangs out?", ["Poor Richard's Pub", "Chili's", "Froggy 101", "The Anthracite Grill"], 0)
    ]
    
    
}

/// 100 тестов = 10 тем x 10 форматов. Названия разные, но вопросы
/// для любого теста берутся из одного общего массива (см. QuizViewModel).
enum TestCatalog {

    private static let logos = [
        "Anthony's Coal Fired Pizza & Wings",
        "Dave's Hot Chicken",
        "Dewey's Pizza",
        "Dion's",
        "Giordano's",
        "Jet's Pizza",
        "Marco's Pizza",
        "Wing Snob"
    ]

    private static let themes = [
        "Pizza", "Wings", "Burgers", "Pasta", "Sushi",
        "Tacos", "Desserts", "Coffee", "Street Food", "BBQ"
    ]

    private static let formats = [
        "Connoisseur Quiz", "Blind Taste Challenge", "Regional Styles", "Ingredient Hunt",
        "Spice Tolerance", "Myth Busters", "Chef Basics", "Calorie Guess",
        "Menu Master", "Flavor Pairing"
    ]

    static let all: [QuizTopic] = {
        var list: [QuizTopic] = []
        var id = 0
        for format in formats {
            for theme in themes {
                list.append(QuizTopic(
                    id: id,
                    title: "\(theme) \(format)",
                    subtitle: "10–15 questions",
                    imageAsset: logos[id % logos.count]
                ))
                id += 1
            }
        }
        return list
    }()

    private static func pick(offset: Int, step: Int, count: Int) -> [QuizTopic] {
        (0..<count).map { all[(offset + $0 * step) % all.count] }
    }

    static let homeSections: [HomeSection] = [
        HomeSection(title: "🔥 Hot Today",       topics: pick(offset: 0, step: 7,  count: 8)),
        HomeSection(title: "⭐️ Most Popular",    topics: pick(offset: 3, step: 11, count: 8)),
        HomeSection(title: "⚡️ Quick Picks",     topics: pick(offset: 5, step: 13, count: 8)),
        HomeSection(title: "🆕 New This Week",   topics: pick(offset: 9, step: 9,  count: 8))
    ]
}
