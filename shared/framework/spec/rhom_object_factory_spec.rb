#
#  rhom_object_factory_spec.rb
#  rhodes
#
#  Copyright (C) 2008 Lars Burgess. All rights reserved.
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
require File.dirname(__FILE__) + "/spec_helper"

describe "RhomObjectFactory" do

  it_should_behave_like "rho initializer"
  
  before(:each) do
    FileUtils.cp_r('spec/syncdbtest.sqlite','build/syncdbtest.sqlite')
  end
  
  after(:each) do 
    FileUtils.rm_rf('build/syncdbtest.sqlite')
    @rhom = nil
  end
  
  it "should set source_id attributes" do
    "1".should == Account.get_source_id
    "2".should == Case.get_source_id
  end
  
  it "should dynamically assign values" do
    account = Account.new
    account.name = 'hello name'
    account.industry = 'hello industry'
    account.object = '3560c0a0-ef58-2f40-68a5-fffffffffffff'
    account.value = 'xyz industries'
    account.name.should == 'hello name'
    account.industry.should == 'hello industry'
    account.object.should == '3560c0a0-ef58-2f40-68a5-fffffffffffff'
    account.value.should == 'xyz industries'
  end
  
  it "should retrieve Case models" do
    results = Case.find(:all)
    #array_print(results)
    results.length.should == 5
    "60".should == results[0].case_number
    "hire another engineer".should == results[4].name
  end
  
  it "should retrieve Account models" do
    results = Account.find(:all)
    results.length.should == 5
    #array_print(results)
    
    "Mobio India".should == results[0].name
    "Technology".should == results[0].industry
    "Aeroprise".should == results[1].name
    "Technology".should == results[1].industry
    "Electronics".should == results[4].industry
    "Mirapath".should == results[4].name
  end
  
  it "should have correct number of attributes" do
    @account = Account.find(:all).first
    
    # expecting name, industry, update_type, object, source_id
    @account.instance_variables.size.should == 5
  end
  
  it "should calculate same djb_hash" do
    vars = {"name"=>"foobarthree", "industry"=>"entertainment"}
    account = Account.new(vars)
    account.object.should == "272128608299468889014"
  end
  
  it "should create a record" do
    vars = {"name"=>"some new record", "industry"=>"electronices"}
    @account1 = Account.new(vars)
    new_id = @account1.object
    @account1.save
    @account2 = Account.find(new_id)
    @account2.object.should =="{#{@account1.object}}"
    @account2.name.should == vars['name']
    @account2.industry.should == vars['industry']
  end
  
  it "should destroy a record" do
    count = Account.find(:all).size
    @account = Account.find(:all)[0]
    destroy_id = @account.object
    @account.destroy
    @account_nil = Account.find(destroy_id)
    
    @account_nil.size.should == 0
    new_count = Account.find(:all).size
    
    (count - 1).should == new_count
  end
  
  it "should partially update a record" do
    new_attributes = {"name"=>"Mobio US"}
    @account = Account.find(:all).first
    @account.update_attributes(new_attributes)
    
    @new_acct = Account.find(:all).first
    
    "Mobio US".should == @new_acct.name
    "Technology".should == @new_acct.industry
  end
  
  it "should fully update a record" do
    new_attributes = {"name"=>"Mobio US", "industry"=>"Electronics"}
    @account = Account.find(:all).first
    @account.update_attributes(new_attributes)
    
    @new_acct = Account.find(:all).first
    
    "Mobio US".should == @new_acct.name
    "Electronics".should == @new_acct.industry
  end
end
