class Kondate < ApplicationRecord
  belongs_to :main_recipe, class_name: "Recipe"

  belongs_to :user

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 512 }
  validates :side_recipe_ids, presence: true, length: { minimum: 1 }

  def side_recipes
    Recipe.where(id: side_recipe_ids.split(","))
  end

  def side_recipes=(recipes)
    @side_recipe_ids = recipes.map { |r| r.id }.join(",")
  end
end
