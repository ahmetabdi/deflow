class Helper

  def self.random
    range = [*'0'..'9', *'a'..'z', *'A'..'Z']
    return Array.new(8){range.sample}.join
  end

  def self.categories
    { "Abstract" => 1,
      "Animal" => 2,
      "Anime" => 3,
      "Artistic" => 4,
      "CGI" => 5,
      "Cartoon" => 6,
      "Celebrity" => 7,
      "Comics" => 8,
      "Dark" => 9,
      "Earth" => 10,
      "Fantasy" => 11,
      "Food" => 12,
      "Game" => 13,
      "Holiday" => 14,
      "Humor" => 15,
      "Man Made" => 16,
      "Men" => 17,
      "Military" => 18,
      "Misc" => 19,
      "Movie" => 20,
      "Multi Monitor" => 21,
      "Music" => 22,
      "Pattern" => 23,
      "Photography" => 24,
      "Products" => 25,
      "Religious" => 26,
      "Sci-Fi" => 27,
      "Sports" => 28,
      "Tv Shows" => 29,
      "Technology" => 30,
      "Vehicles" => 31,
      "Video Games" => 32,
      "Weapons" => 33,
      "Women" => 34,
    }
  end

end