class ProjMushroomIdCli::Cli 

    def self.run
        get_info
        main_menu
    end

    BASE_URL = "http://www.foragingguide.com/mushrooms/articles/general/your_first_10_wild_mushrooms"
    

    # def run < DONE
    # make mushrooms < DONE 
    # add_attributes_to_mushrooms < DONE
    # display_mushrooms << NEED TO IMPROVE THIS, USE COLORIZE TO MAKE IT PRETTY
    # sort methods << MAY WANT TO ADD THIS
    # end

    def self.get_info
        mushrooms_array = ProjMushroomIdCli::Scraper.scrape_index_page(BASE_URL)
        ProjMushroomIdCli::Mushroom.create_from_collection(mushrooms_array)
        add_attributes_to_mushrooms
    end

    def self.add_attributes_to_mushrooms
        ProjMushroomIdCli::Mushroom.all.each do |mushroom|
            attributes = ProjMushroomIdCli::Scraper.scrape_profile_page(mushroom.link)
            mushroom.add_mushroom_attributes(attributes)
        end
    end

    def self.main_menu
        print_main_menu
        input = ""
        while input != "exit" 
            
            input = gets.chomp.downcase
            # case input
            #     when "read intro"
            #         print_intro
            #     when "all"
            #         list_all 
            #     when "menu"
            #         print_main_menu
            #     when "select"
            #         mushroom = select_mushroom
            #         print_description(mushroom)
            #     when "link"
            #         link_mushroom
            #     else
            #         puts "\n\n\nI'm sorry! You entered an invalid input. Please be mindful of the menu selection options.\n\n"
            # end
            # print_main_menu
            if input == "read intro"
                print_intro
            elsif input == "all"
                list_all 
            elsif input == "menu"
                print_main_menu
            elsif input == "select"
                mushroom = select_mushroom
                print_description(mushroom) if mushroom.class == ProjMushroomIdCli::Mushroom
            elsif input == "link"
                link_mushroom
            else
                puts "\n\n\nI'm sorry! You entered an invalid input. Please be mindful of the menu selection options.\n\n"
            end
            print_main_menu
        end
    end

    def self.print_main_menu
        puts " \n--THE MUSHROOM FORAGING DATABASE--"
        puts " \n-----------MAIN MENU-----------"
        puts "To read an intro, type 'read intro'."
        puts "To read all of the mushroom foraging info, type 'all'."
        puts "To get a description of a specific mushroom, type 'select'."
        puts "To get a link to images of a specific mushroom, type 'link'."        
        puts "To quit, type 'exit'."
    end

    #------------------------------
    #------------------------------
    #------------------------------
    #------------------------------
    
    def self.print_intro      
        puts " \n --- #{ProjMushroomIdCli::Scraper.introtext}"
        list_all_mushroom_names
    end

    def self.list_all
        ProjMushroomIdCli::Mushroom.all.each{ |mushroom|
            puts "------------------------------------\n------------------------------------\n\n"
            print_description(mushroom)
            puts "------------------------------------\n------------------------------------\n\n"
        }   
    end

    def self.list_all_mushroom_names
        puts "\n"
        ProjMushroomIdCli::Mushroom.all.each.with_index{ |mushroom, i|
            puts "#{i+1}. #{mushroom.common_name}"
        }
    end

    
    def self.select_mushroom
        list_all_mushroom_names
        firstTime = true
        mushroom = nil
        found = false
        
        while !found  
            found = false
            num = nil
            puts "\n ---I'm sorry! I didn't get that. Please enter one of the numbers of an available mushroom. \n" if !firstTime
            puts "\nPlease type the number of the mushroom you'd like to select. \nOr you can type 'menu' to return to the main menu.\n"
            num = gets.chomp
            return if num == 'menu'
            num = num.to_i
            if num > 0 && num < 11
                # binding.pry
                mushroom = ProjMushroomIdCli::Mushroom.all[num-1]
                found = true if mushroom.class == ProjMushroomIdCli::Mushroom
            end
            firstTime = false
        end
        mushroom
    end
    
    # def self.select_mushroom
    #     input = nil
    #     found = false
    #     mushroom = nil
        
    #     while !found  
    #         list_all_mushroom_names
    #         puts "\nPlease type the number of the mushroom you'd like to select: \n"
    #         input = gets.chomp
    #         if input == exit 
    #             return
    #         elsif input.to_i > 0 && input.to_i <= mushroom.all.count
    #             input = (input.to_i - 1)
    #             mushroom = ProjmushroomIdCli::mushroom.all[input]
    #             found = true if mushroom.class == ProjmushroomIdCli::mushroom
    #         else
    #             puts "\n\n\nI'm sorry! You entered an invalid input. Please be mindful of the menu selection options.\n\n"
    #         end
    #     end
    #     mushroom
    # end

    def self.print_description(mushroom)
        mushroom.class.expectedInfoTypes.each {|infoType|
            if mushroom.send("#{infoType}")         
                puts " -- #{infoType.upcase.to_s.split("_").join(" ")}"
                puts " ---- #{mushroom.send("#{infoType}")}\n\n"
            end
        }

    end

    def self.link_mushroom
        mushroom = select_mushroom
        puts mushroom.link if mushroom.class == ProjMushroomIdCli::Mushroom
    end

    # def self.search_mushroom
    #     list_all_mushroom_names
    #     puts "\nPlease type the name of the mushroom you'd like to search: \n"
    #     name = gets.chomp
    #     nameA = name.split(" ")
    #     print "https://www.google.com/search?q="
    #     nameA.each {|word| 
    #         print "#{word}"
    #         print "+" if word != nameA[-1]
    #     }
    #     puts ""
    # end


    # def display_students
    # Student.all.each do |student|
    #     puts "#{student.name.upcase}".colorize(:blue)
    #     puts "  location:".colorize(:light_blue) + " #{student.location}"
    #     puts "  profile quote:".colorize(:light_blue) + " #{student.profile_quote}"
    #     puts "  bio:".colorize(:light_blue) + " #{student.bio}"
    #     puts "  twitter:".colorize(:light_blue) + " #{student.twitter}"
    #     puts "  linkedin:".colorize(:light_blue) + " #{student.linkedin}"
    #     puts "  github:".colorize(:light_blue) + " #{student.github}"
    #     puts "  blog:".colorize(:light_blue) + " #{student.blog}"
    #     puts "----------------------".colorize(:green)
    # end
    # end

end