require 'spec_helper'

describe Capybara::Driver::Webkit do
  subject { Capybara::Driver::Webkit.new(@app, :browser => $webkit_browser) }
  before { subject.visit("/hello/world?success=true") }
  after { subject.reset! }

  context "form app" do
      before(:all) do
        @app = lambda do |env|
          fixture = File.expand_path("../fixture.html", __FILE__)
          body = IO.readlines(fixture).join("\n")
          [200,
            { 'Content-Type' => 'text/html', 'Content-Length' => body.length.to_s },
            [body]]
        end
      end

      let(:text_box)        { subject.find("//input").first }
      let(:animal_select)   { subject.find("//select[@name='animal']").first }
      let(:toppings_select) { subject.find("//select[@name='toppings']").first }

      it "sets an input value via javascript" do
         text_box.value.should == "bar"
         subject.evaluate_script("setInputValue('baz');")
         text_box.value.should == "baz"
      end

      it "sets a single select value via javascript" do
         animal_select.value.should == "Capybara"
         subject.evaluate_script("selectMonkey();")
         animal_select.value.should == "Monkey"
      end

      it "should clear multi-select selections via javascript" do
         subject.find("//select[@name='toppings']//option[@selected='selected']").length.should == 3
         toppings_select.value.should == ["Apple", "Banana", "Cherry"]
         subject.evaluate_script("clearSelections();")
         toppings_select.value.should == []
         subject.find("//select[@name='toppings']//option[@selected='selected']").length.should == 0
      end

  end

end
