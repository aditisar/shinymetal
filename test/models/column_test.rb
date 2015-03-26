require 'test_helper'

class ColumnTest < ActiveSupport::TestCase
  #Relationships
  should have_many(:user_key_columns)
  should have_many(:user_keys).through(:user_key_columns)
  
  context "Creating a columns context" do
    setup do
      create_columns
    end
    
    teardown do
      destroy_columns
    end
    
    should "have a method to return the columns name" do
      assert_equal "Description", @organizations_description_column.name
    end
	
    should "have a scope to sort columns alphabetically" do
      assert_equal [["organizations", "Description"], ["events", "EventName"]],
                   Column.alphabetical.to_a.map {|f| [f.resource, f.name]}
    end
    
    should "have a scope to restrict column resources" do
      assert_equal [["organizations", "Description"]],
                   Column.alphabetical.restrict_to("organizations").to_a.map {|f| [f.resource, f.name]}
    end

    should "have a method to test for invalid column names" do
      bad_column = FactoryGirl.build(:column, column_name: "bad")
      deny bad_column.valid?
    end
  end
end
