require 'spec_helper'
require 'tmpdir'

module Lightchef
  describe Runner do
    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          example.run
        end
      end
    end

    describe ".new_from_options" do
      before do
        open('./node.json', 'w') {|f| f.write '{"foo": "bar"}' }
      end
      it "returns Runner" do
        runner = described_class.new_from_options(node_json: "./node.json")
        expect(runner.node['foo']).to eq 'bar'
      end
    end

    describe ".run" do
      let(:recipes) { %w! ./recipe1.rb ./recipe2.rb ! }
      it "runs each recipe with the runner" do
        recipes.each do |r|
          recipe = double(:recipe)
          Recipe.stub(:new).with(File.expand_path(r)).and_return(recipe)
          expect(recipe).to receive(:run)
        end
        described_class.run(recipes)
      end
    end
  end
end
