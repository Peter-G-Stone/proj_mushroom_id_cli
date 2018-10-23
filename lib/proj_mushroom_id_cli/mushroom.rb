class ProjMushroomIdCli::Mushroom
    
    @@all = []
    
    attr_accessor :link, :common_name, :latin_name, :edibility, :eating_notes, :preserving, :cap, :fruit_body, :gills, :stem, :tubes, :pores, :spore_surface, :spores, :flesh, :habitat, :frequency

    @@expectedInfoTypes = [:common_name, :latin_name, :edibility, :eating_notes, :preserving, :cap, :fruit_body, :gills, :stem, :tubes, :pores, :spore_surface, :spores, :flesh, :habitat, :frequency, :link]

    def initialize(mushroom_hash)
        mushroom_hash.each{|k,v| self.send(("#{k}="), v)}
        @@all << self
      end
    
    def self.create_from_collection(mushrooms_array)
        mushrooms_array.each { |mushroom|
        ProjMushroomIdCli::Mushroom.new(mushroom)
        }
    end 

    def add_mushroom_attributes(attributes_hash)
        
        attributes_hash.each{|k,v| 
            
            self.send(("#{k}="), v)
        }
        
    end

    def self.find_by_common_name(common_name)
        self.all.find{ |mushroom| mushroom.common_name.downcase == common_name.downcase}
    end
    
    def self.all
        @@all
    end

    def self.expectedInfoTypes
        @@expectedInfoTypes
    end
end