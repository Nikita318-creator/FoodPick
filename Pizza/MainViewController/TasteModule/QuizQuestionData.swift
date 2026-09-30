import UIKit


enum Theme {
   static let ink        = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
   static let background = UIColor(red: 0.98, green: 0.97, blue: 0.95, alpha: 1.0)
   static let accent     = UIColor(red: 1.00, green: 0.78, blue: 0.23, alpha: 1.0)
   static let card       = UIColor.white
   static let border     = UIColor.systemGray5
   static let correct    = UIColor(red: 0.50, green: 0.90, blue: 0.50, alpha: 1.0)
   static let wrong      = UIColor(red: 0.90, green: 0.50, blue: 0.50, alpha: 1.0)

   static func applyCardStyle(to view: UIView, cornerRadius: CGFloat = 20) {
       view.backgroundColor = card
       view.layer.cornerRadius = cornerRadius
       view.layer.borderWidth = 1.5
       view.layer.borderColor = border.cgColor
   }
}


/// Единый большой массив вопросов. Просто добавляй новые строки через q(...).
/// Формат: q("Вопрос", ["A", "B", "C", "D"], индекс правильного)
enum QuestionBank {

    private static func q(_ text: String, _ options: [String], _ correct: Int) -> QuizQuestion {
        QuizQuestion(text: text, options: options, correctAnswerIndex: correct)
    }

    static let all: [QuizQuestion] = [
        q("Which city is famous for its deep-dish pizza?", ["New York", "Chicago", "Naples", "Detroit"], 1),
        q("What gives Nashville Hot Chicken its signature heat?", ["Wasabi", "Black pepper", "Cayenne pepper", "Horseradish"], 2),
        q("Coal-fired pizza ovens typically reach about…", ["400°F", "600°F", "900°F", "1500°F"], 2),
        q("Which feature is typical for Detroit-style pizza?", ["Crispy cheesy corners", "Paper-thin crust", "Stuffed crust", "No cheese"], 0),
        q("Classic Buffalo wings are tossed in…", ["Honey BBQ", "Hot sauce and butter", "Teriyaki", "Mustard"], 1),
        q("A traditional Margherita pizza is topped with…", ["Pepperoni and onion", "Tomato, mozzarella and basil", "Ham and pineapple", "Four cheeses"], 1),
        q("Nori, used in sushi rolls, is made from…", ["Rice paper", "Seaweed", "Soy beans", "Tea leaves"], 1),
        q("The green paste served with sushi is often made from…", ["Horseradish", "Avocado", "Mint", "Spinach"], 0),
        q("The main ingredient of guacamole is…", ["Tomato", "Lime", "Avocado", "Cucumber"], 2),
        q("Paella originally comes from which country?", ["Italy", "Mexico", "Portugal", "Spain"], 3),
        q("Traditional carbonara does NOT include…", ["Eggs", "Cream", "Pecorino", "Guanciale"], 1),
        q("The Scoville scale measures…", ["Sweetness", "Acidity", "Spiciness", "Saltiness"], 2),
        q("Which pepper is the hottest?", ["Jalapeño", "Serrano", "Habanero", "Carolina Reaper"], 3),
        q("Kimchi is most commonly made from fermented…", ["Cabbage", "Potatoes", "Rice", "Beans"], 0),
        q("The Italian word 'tiramisu' roughly means…", ["Sweet dream", "Pick me up", "Cold coffee", "Little cake"], 1),
        q("Hummus is primarily made from…", ["Lentils", "Chickpeas", "Eggplant", "Sesame leaves"], 1),
        q("Which cheese is traditional in a Greek salad?", ["Cheddar", "Brie", "Feta", "Gouda"], 2),
        q("A cappuccino is traditionally made with espresso, steamed milk and…", ["Cream", "Milk foam", "Chocolate syrup", "Condensed milk"], 1),
        q("Pad Thai is a famous dish from…", ["Vietnam", "Thailand", "Laos", "Indonesia"], 1),
        q("Ghee is…", ["Fermented milk", "Clarified butter", "Coconut oil", "A type of yogurt"], 1),
        q("Bruschetta is typically served on…", ["Toasted bread", "Fried dough", "Flatbread", "Crackers"], 0),
        q("Tacos al pastor are traditionally made with…", ["Beef", "Chicken", "Pork", "Fish"], 2),
        q("Ramen is a noodle soup from…", ["China only", "Korea", "Japan", "Philippines"], 2),
        q("A Chicago-style hot dog is famously served without…", ["Mustard", "Ketchup", "Onions", "Pickles"], 1),
        q("Compared to ice cream, gelato is usually…", ["Denser, with less air", "Fluffier, with more air", "Made without milk", "Served frozen solid"], 0),
        q("Mole sauce is a classic of which cuisine?", ["Peruvian", "Spanish", "Mexican", "Cuban"], 2),
        q("Baklava is made from layers of…", ["Puff pastry and cream", "Phyllo dough and nuts", "Sponge cake and jam", "Bread and cheese"], 1),
        q("Falafel is traditionally made from…", ["Ground chickpeas or fava beans", "Minced lamb", "Rice flour", "Potatoes"], 0),
        q("Which spice is the most expensive by weight?", ["Vanilla bean", "Cardamom", "Saffron", "Cinnamon"], 2),
        q("Fondue is traditionally a dish of…", ["Melted cheese", "Fried meat", "Cold soup", "Baked vegetables"], 0),
        q("New York-style pizza slices are known for being…", ["Thick and square", "Large, thin and foldable", "Served in a bowl", "Topped with raw egg"], 1),
        q("Sourdough bread rises thanks to…", ["Baking soda", "Wild yeast and bacteria", "Whipped eggs", "Beer only"], 1),
        q("Umami is described as which taste?", ["Sour", "Bitter", "Savory", "Sweet"], 2),
        q("The top of a crème brûlée is…", ["Whipped cream", "Caramelized sugar", "Chocolate glaze", "Fresh berries"], 1),
        q("Pho is a noodle soup from…", ["Vietnam", "China", "Thailand", "Cambodia"], 0),
        q("Steak tartare is made from…", ["Raw beef", "Smoked salmon", "Braised pork", "Fried chicken"], 0),
        q("Tzatziki is based on…", ["Hummus and tahini", "Yogurt and cucumber", "Feta and olives", "Tomato and garlic"], 1),
        q("Empanadas are…", ["Filled pastries", "Fried rice balls", "Corn soups", "Grilled skewers"], 0),
        q("Traditional pesto is made with which herb?", ["Parsley", "Basil", "Mint", "Cilantro"], 1),
        q("The Maillard reaction is responsible for…", ["Freezing food", "Browning and flavor when cooking", "Fermenting dough", "Curdling milk"], 1),
        q("Naan bread is traditionally baked in a…", ["Tandoor", "Steamer", "Wok", "Smoker"], 0),
        q("Which rice is classic for risotto?", ["Basmati", "Jasmine", "Arborio", "Sushi rice"], 2),
        q("Churros are…", ["Fried dough sticks dusted with sugar", "Stuffed peppers", "Corn dumplings", "Baked cheese sticks"], 0),
        q("Which part of the cow is brisket?", ["Chest", "Hind leg", "Neck", "Rib cage side"], 0),
        q("Low-and-slow barbecue is usually cooked over…", ["High open flame", "Indirect heat and smoke", "Boiling water", "A microwave"], 1),
        q("Miso paste is made from fermented…", ["Soybeans", "Seaweed", "Wheat noodles", "Fish"], 0),
        q("What does 'al dente' describe?", ["Pasta cooked firm to the bite", "Very spicy sauce", "Grilled cheese", "Overcooked vegetables"], 0),
        q("Which nut is the main ingredient of marzipan?", ["Pistachio", "Almond", "Walnut", "Hazelnut"], 1),
        q("What is the main spirit used in a classic Mojito?", ["Vodka", "Rum", "Tequila", "Gin"], 1),
        q("Which pasta is shaped like small rice grains?", ["Orzo", "Penne", "Farfalle", "Rigatoni"], 0),
        q("Traditional French ratatouille is primarily made of…", ["Beef and potatoes", "Stewed vegetables", "Seafood mix", "Cheese and eggs"], 1),
        q("Which region in Italy is famous for Parmigiano-Reggiano?", ["Emilia-Romagna", "Tuscany", "Sicily", "Lombardy"], 0),
        q("A traditional French croissant is made using lots of…", ["Margarine", "Butter", "Lard", "Olive oil"], 1),
        q("What type of nut is inside a traditional pesto alla Genovese?", ["Pecan", "Pine nut", "Walnut", "Cashew"], 1),
        q("What is the primary ingredient in traditional tofu?", ["Soy milk", "Rice flour", "Wheat gluten", "Coconut cream"], 0),
        q("Which sauce is essential for Eggs Benedict?", ["Béarnaise", "Hollandaise", "Velouté", "Espagnole"], 1),
        q("Shakshuka is a popular dish consisting of poached eggs in…", ["Spicy tomato sauce", "Creamy mushroom sauce", "Pesto", "Beef broth"], 0),
        q("Which Asian country is famous for Pho and Bánh mì?", ["Thailand", "Vietnam", "Japan", "Malaysia"], 1),
        q("What gives a bagel its unique chewy texture before baking?", ["Boiling in water", "Deep frying", "Freezing", "Steaming"], 0),
        q("What is the key ingredient in a classic Caesar dressing?", ["Anchovies", "Sour cream", "Peanut butter", "Yogurt"], 0),
        q("Which popular Mexican dish features a folded tortilla with cheese?", ["Quesadilla", "Tamale", "Burrito", "Enchilada"], 0),
        q("Goulash is a traditional stew originating from…", ["Hungary", "Poland", "Germany", "Czech Republic"], 0),
        q("Which type of tea is fully oxidized?", ["Green tea", "Black tea", "White tea", "Oolong tea"], 1),
        q("What is the base of a traditional Spanish gazpacho?", ["Warm beef broth", "Cold raw vegetables", "Boiled potatoes", "Melted cheese"], 1),
        q("Which condiment is traditional for Japanese tempura?", ["Tentsuyu sauce", "Ketchup", "Marinara", "Ranch"], 0),
        q("What gives red curry its rich red color?", ["Red chili peppers", "Beetroot", "Paprika powder", "Tomato paste"], 0),
        q("Bacon is primarily cut from which part of the pig?", ["Pork belly or back", "Leg", "Shoulder", "Snout"], 0),
        q("Which French soup is famous for its caramelized onion base?", ["French Onion Soup", "Bouillabaisse", "Consommé", "Bisque"], 0),
        q("What key ingredient gives chimichurri sauce its green color?", ["Parsley", "Spinach", "Avocado", "Green pepper"], 0),
        q("Which spice is commonly used in mulled wine and pumpkin pie?", ["Cinnamon", "Cumin", "Turmeric", "Mustard seed"], 0),
        q("What type of bread is traditionally used for a French croque-monsieur?", ["Brioche or white bread", "Rye bread", "Pita", "Baguette only"], 0),
        q("Fish and Chips are traditionally served with a side of…", ["Mushy peas", "Sauerkraut", "Rice", "Mashed sweet potato"], 0),
        q("What is the main flavoring agent in Earl Grey tea?", ["Bergamot oil", "Jasmine flowers", "Vanilla extract", "Mint leaves"], 0),
        q("Which fruit is known as the 'king of fruits' in Southeast Asia?", ["Durian", "Mango", "Papaya", "Lychee"], 0),
        q("A classic Tom Yum soup from Thailand is known for being…", ["Sour and spicy", "Sweet and creamy", "Salty and thick", "Bland and clear"], 0),
        q("Which ingredient is used to thicken a classic roux?", ["Flour", "Cornstarch", "Gelatin", "Egg yolk"], 0),
        q("What style of coffee is made with equal parts espresso, steamed milk, and foam?", ["Cappuccino", "Latte", "Americano", "Macchiato"], 0),
        q("Which Italian dessert consists of sweetened cream thickened with gelatin?", ["Panna Cotta", "Cannoli", "Gelato", "Tiramisu"], 0),
        q("Which region of France is world-famous for its sparkling wine?", ["Champagne", "Bordeaux", "Burgundy", "Provence"], 0),
        q("What type of pasta translates to 'little ribbons' in Italian?", ["Fettuccine", "Penne", "Farfalle", "Spaghetti"], 0),
        q("Which legume is used to make traditional Indian dhal?", ["Lentils", "Chickpeas", "Soybeans", "Black beans"], 0),
        q("What is the traditional sauce served with a German Wiener Schnitzel?", ["Lemon slices", "Gravy", "Mushroom sauce", "Ketchup"], 0),
        q("What primary grain is used to make traditional Japanese sake?", ["Rice", "Barley", "Wheat", "Corn"], 0),
        q("Which herb is the key ingredient in a classic French Bearnaise sauce?", ["Tarragon", "Thyme", "Rosemary", "Oregano"], 0),
        q("What gives Japanese matcha tea its vibrant green color?", ["Shaded tea leaves", "Green food dye", "Algae powder", "Spinach juice"], 0),
        q("Which Spanish cold soup is made primarily of almonds and garlic?", ["Ajoblanco", "Gazpacho", "Salmorejo", "Caldo verde"], 0),
        q("What type of wrapper is used for traditional Chinese dim sum har gow?", ["Tapioca and wheat starch", "Egg noodle dough", "Rice paper", "Seaweed"], 0),
        q("Which spice gives traditional Indian golden milk its distinct color?", ["Turmeric", "Curry powder", "Cinnamon", "Ginger"], 0),
        q("What is the classic cheese used in a Swiss Fondue Moitie-Moitie?", ["Gruyere and Vacherin", "Cheddar and Gouda", "Brie and Camembert", "Mozzarella and Parmesan"], 0),
        q("What type of meat is traditionally used in a classic Shepherd's Pie?", ["Lamb", "Beef", "Pork", "Chicken"], 0),
        q("Which Italian cured meat is made from pork neck or shoulder?", ["Capocollo", "Prosciutto", "Pancetta", "Salami"], 0),
        q("What is the primary flavor profile of a classic Thai Green Curry?", ["Coconut and green chili", "Sweet and sour", "Heavy tomato", "Earthy turmeric"], 0),
        q("Which fruit is traditionally used to make authentic Worcestershire sauce?", ["Tamarind", "Plum", "Apple", "Fig"], 0),
        q("What gives black pasta (pasta al nero di seppia) its dark color?", ["Squid ink", "Black sesame", "Charcoal", "Dark soy sauce"], 0),
        q("Which French pastry consists of choux dough filled with cream and topped with chocolate?", ["Eclair", "Macaron", "Tarte Tatin", "Mille-feuille"], 0),
        q("What type of vinegar is essential for making traditional sushi rice?", ["Rice vinegar", "Apple cider vinegar", "Balsamic vinegar", "White wine vinegar"], 0),
        q("Which cheese is traditionally protected by AOC and made in Roquefort-sur-Soulzon?", ["Roquefort", "Gorgonzola", "Stilton", "Danish Blue"], 0),
        q("What is the main protein in the classic Brazilian stew Feijoada?", ["Black beans and pork", "Chicken and rice", "Beef and potatoes", "Fish and shrimp"], 0),
        q("Which Mexican street food consists of grilled corn on the cob with mayo and cheese?", ["Elote", "Tamale", "Tostada", "Chalupa"], 0),
        q("What is the main aromatic ingredient in a French Bouquet Garni?", ["Thyme and parsley", "Basil and oregano", "Mint and cilantro", "Cumin and coriander"], 0),
        q("Which key element makes Belgian waffles different from American waffles?", ["Yeast or whipped egg whites", "Baking powder only", "Cornmeal base", "No sugar added"], 0),
        q("What is the traditional base of an authentic Japanese dashi broth?", ["Kombu and bonito flakes", "Chicken bones", "Pork belly", "Miso and garlic"], 0),
        q("Which Italian bread is baked with olive oil and often topped with rosemary or salt?", ["Focaccia", "Ciabatta", "Panettone", "Grissini"], 0),
        q("What is the classic oil used for frying authentic Spanish churros?", ["Olive oil or sunflower oil", "Butter", "Sesame oil", "Coconut oil"], 0),
        q("Which Middle Eastern dip is made from roasted eggplant and tahini?", ["Baba Ghanoush", "Hummus", "Labneh", "Muhammara"], 0),
        q("What type of sugar is traditionally used to glaze a Crème Brulee?", ["Caster or granulated sugar", "Brown molasses", "Powdered sugar", "Maple sugar"], 0),
        q("Which famous Italian salad is made with tomatoes, mozzarella, and basil?", ["Caprese", "Panzanella", "Caesar", "Waldorf"], 0),
        q("What gives a classic Manhattan cocktail its red hue?", ["Sweet vermouth", "Cranberry juice", "Grenadine", "Campari"], 0),
        q("Which region in Italy is the birthplace of Pizza Margherita?", ["Naples", "Rome", "Florence", "Venice"], 0),
        q("What type of flour is traditionally used to make Italian pasta?", ["Semolina flour", "Almond flour", "Coconut flour", "Cornmeal"], 0),
        q("Which condiment is famously paired with hot dogs in New York?", ["Yellow mustard", "Mayonnaise", "Tarty tartar sauce", "Sriracha"], 0),
        q("What gives traditional Hawaiian pizza its sweet flavor profile?", ["Pineapple", "Mango", "Honey", "Sweet potato"], 0),
        q("Which country is famous for inventing the croissant?", ["Austria", "France", "Switzerland", "Belgium"], 0),
        q("What primary protein is used in authentic Peking Duck?", ["Duck", "Chicken", "Goose", "Pork"], 0),
        q("Which herb is the key component in traditional Argentine chimichurri?", ["Parsley", "Dill", "Rosemary", "Sage"], 0),
        q("What type of cheese is layered in classic lasagna recipes?", ["Ricotta and Mozzarella", "Cheddar and Swiss", "Brie and Camembert", "Feta and Gouda"], 0),
        q("Which fruit is used to make traditional guacamole?", ["Avocado", "Lime", "Green apple", "Kiwi"], 0),
        q("What gives a traditional Irish Coffee its distinct kick?", ["Irish whiskey", "Dark rum", "Bourbon", "Cognac"], 0),
        q("Which key ingredient thickens a traditional Greek tzatziki sauce?", ["Strained Greek yogurt", "Heavy cream", "Sour cream", "Coconut milk"], 0),
        q("What is the traditional cooking vessel used for Spanish paella?", ["Wide shallow pan", "Deep wok", "Pressure cooker", "Clay pot"], 0),
        q("Which sweetener is traditionally used in authentic baklava?", ["Honey or sugar syrup", "Maple syrup", "Agave nectar", "Molasses"], 0),
        q("What style of pizza is baked in a deep pan with cheese melted to the crust edges?", ["Detroit-style", "Neapolitan", "New York-style", "Roman-style"], 0),
        q("Which Japanese dish consists of deep-fried battered seafood or vegetables?", ["Tempura", "Sashimi", "Yakitori", "Tonkatsu"], 0),
        q("What gives a classic Buffalo chicken dip its orange color and tang?", ["Hot pepper sauce", "Cheddar sauce", "Paprika oil", "Carrot juice"], 0),
        q("Which yeast-leavened flatbread is traditional in Indian cuisine?", ["Naan", "Pita", "Tortilla", "Matzo"], 0),
        q("What primary ingredient makes up traditional hummus?", ["Chickpeas", "Black beans", "Lentils", "Green peas"], 0),
        q("Which spice gives yellow curry its signature golden shade?", ["Turmeric", "Cumin", "Paprika", "Cardamom"], 0),
        q("What type of milk is used to make authentic Mozzarella di Bufala?", ["Water buffalo milk", "Cow milk", "Goat milk", "Sheep milk"], 0),
        q("Which popular Mexican snack features folded corn tortillas filled with meat and cheese?", ["Tacos", "Tamales", "Empanadas", "Arepas"], 0),
        q("What is the main flavor of traditional Italian Amaretto liqueur?", ["Almond", "Hazelnut", "Anise", "Coffee"], 0),
        q("Which French culinary term refers to cutting vegetables into thin matchsticks?", ["Julienne", "Dice", "Brunoise", "Chiffonade"], 0),
        q("What primary spirit is used in a classic Margarita cocktail?", ["Tequila", "Rum", "Vodka", "Gin"], 0),
        q("Which country originated the rich chocolate-hazelnut spread known worldwide?", ["Italy", "Switzerland", "Germany", "Belgium"], 0),
        q("What gives a traditional Caesar salad its signature savory crunch?", ["Croutons", "Fried onions", "Roasted peanuts", "Sunflower seeds"], 0),
        q("Which popular Asian noodle soup features rice noodles, herbs, and broth?", ["Pho", "Ramen", "Udon", "Soba"], 0),
        q("What is the main protein found in a traditional Japanese Tonkatsu cutlet?", ["Pork", "Chicken", "Beef", "Tofu"], 0),
        q("Which popular baking ingredient is made by removing water from butter fat?", ["Ghee", "Lard", "Margarine", "Shortening"], 0),
        q("What type of pastry dough is used to build a traditional French mille-feuille?", ["Puff pastry", "Choux pastry", "Phyllo dough", "Shortcrust pastry"], 0)
    ]
}

/// 100 тестов = 10 тем x 10 форматов. Названия разные, но вопросы
/// для любого теста берутся из одного общего массива (см. QuizViewModel).
enum TestCatalog {

    private static let logos = [
        "anthonys_logo", "daves_logo", "deweys_logo", "dions_logo",
        "giordanos_logo", "jets_logo", "marcos_logo", "wingsnob_logo"
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
