class KondateForm
  include ActiveModel::Validations

  attr_accessor :title, :description, :main_recipe_id, :side_recipe_ids
  attr_reader :kondate

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 512 }
  validates :main_recipe_id, presence: true
  validate :validate_side_recipe_ids

  def initialize(kondate)
    # 起点になるレシピオブジェクトは保存しておく
    @kondate = kondate
    # 必要な情報をフォームにわたす
    @title = kondate.title
    @description = kondate.description
    @main_recipe_id = kondate.main_recipe_id
    @side_recipe_ids = kondate.side_recipe_ids
  end

  def apply(params)
    @title = params[:title]
    @description = params[:description]
    @main_recipe_id = params[:main_recipe_id]
    @side_recipe_ids = params[:side_recipe_ids]
  end

  def save
    return false unless valid?

    @kondate.title = @title
    @kondate.description = @description

    kondate.transaction do
      @kondate.main_recipe_id = @main_recipe_id
      @kondate.side_recipe_ids = @side_recipe_ids
      @kondate.save!
    end

    return true
  end

  # Act like ActiveRecord class
  def persisted?
    @kondate.persisted?
  end

  private def validate_side_recipe_ids
    unless @side_recipe_ids.split(",").size > 0
      errors.add(:side_recipe_ids, 'has more than 1 side recipe.')
    end
  end
end
