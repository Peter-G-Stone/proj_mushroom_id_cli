class Plant
    
    @@all = []
    
    attr_accessor :name, :link, :commonName, :latinName, :edibility, :eating_notes, :preserving, :cap, :fruit_body, :gills, :stem, :tubes, :pores, :spores, :flesh, :habitat, :frequency

    @@expectedInfoTypes = [:name, :link, :commonName, :latinName, :edibility, :eating_notes, :preserving, :cap, :fruit_body, :gills, :stem, :tubes, :pores, :spores, :flesh, :habitat, :frequency]

    def initialize(plant_hash)
        plant_hash.each{|k,v| self.send(("#{k}="), v)}
        @@all << self
      end
    
    def self.create_from_collection(plants_array)
        plants_array.each { |plant|
            Plant.new(plant)
        }
    end 

    def add_plant_attributes(attributes_hash)
        attributes_hash.each{|k,v| self.send(("#{k}="), v)}
    end

    def self.find_by_name(name)
        self.all.find{ |plant| plant.name.downcase == name.downcase}
    end
    
    def self.all
        @@all
    end

    def self.expectedInfoTypes
        @@expectedInfoTypes
    end
end