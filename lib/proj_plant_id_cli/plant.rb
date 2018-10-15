class Plant
    
    @@all = []
    
    attr_accessor :name, :description

    def initialize(student_hash)
        student_hash.each{|k,v| self.send(("#{k}="), v)}
        @@all << self
      end
    
    def self.create_from_collection(plants_array)
        plants_array.each { |plant|
            Plant.new(plant)
        }
    end 

    # def add_plant_attributes(attributes_hash)
    #     attributes_hash.each{|k,v| self.send(("#{k}="), v)}
    # end

    def self.find_by_name(name)
        self.all.find{ |plant| plant.name == name}
    end
    
    def self.all
        @@all
    end
end