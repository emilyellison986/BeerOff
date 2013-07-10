class Brewery
  
  # Gems
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Associations
  has_many :beers, foreign_key: :breweryId
  
  # Scopes
  default_scope order_by('created_at asc') 
  
  # Attributes
  field :name, type: String
  field :description, type: String
  field :website, type: String
  field :established, type: String
  field :isOrganic, type: String
  field :images, type: Hash
  field :bd_id, type: String
  field :_id, type: String, default: ->{ bd_id }
  
  # Class Methods
  def self.import_for_year year
    page = 1
    importer = { 'current_page' => 0, 'number_of_pages' => 1 }
    until importer['current_page'] == importer['number_of_pages']
      importer = Importer.new(Brewery, BreweryDb.breweries_established_in(year, page: page)).as_json
      page += 1
    end
  end
  
  def self.import_for_years year_array
    year_array.each do |year|
      self.import_for_year year
    end
  end
  
end