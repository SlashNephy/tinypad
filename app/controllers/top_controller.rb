class TopController < ApplicationController
  def index
    @recent_kondates = Kondate.order(id: :desc).limit(10)
    @recent_recipes = Recipe.order(id: :desc).limit(10)
    @recent_tsukurepos = Tsukurepo.order(id: :desc).limit(10)
  end
end
