require_relative "./spec_helper.rb"
require_relative "../lib/toc"

class MockItem
	attr_accessor :identifier, :attributes
	def initialize name, att = {}
		@attributes = { :section => "lectures" }.merge(att)
		@identifier = name
	end

	def [](index)
		@attributes[index]
	end

	def self.gen (names)
		items = []
		order = [5,2,12,4,8,3,1,6]
		names.each { |nm| items << MockItem.new(nm, {order: order.pop}) }
		items
	end
end

describe Toc do
	let(:items) {
			MockItem.gen(
			 		%w(/lectures/hypotheses/ /lectures/ideation/
			 		/lectures/lean_immersion/welcome/
			 		/lectures/lean_startup/) ) }

	it "initializes" do
		toc = Toc.instance
		toc.reset
		toc.prepare items
	end


	describe "next and previous methods" do
		let(:items) {
			MockItem.gen(%w(/lectures/a/ /lectures/b/ /lectures/c/ /lectures/d/) )
		}
		before (:each) do 
			@toc = Toc.instance
			@toc.reset
			@toc.prepare items
		end

		it "next"  do
			i = @toc.lookup_by_index(:lectures, 2)
			i_plus_one = @toc.find_next_for(i)
			expect(i_plus_one).to eq @toc.lookup_by_index(:lectures, 3)
		end

		it "prev"  do
			i = @toc.lookup_by_index(:lectures, 1)
			i_minus_one = @toc.find_previous_for(i)
			expect(i_minus_one).to eq @toc.lookup_by_index(:lectures, 0)
		end
	end

	describe "Trivial case of subsections" do
		let(:items) {
			MockItem.gen(
			 		%w(/lectures/hypotheses/ /lectures/ideation/
			 		/lectures/welcome/
			 		/lectures/lean_startup/) ) }
		before (:each) do 
			@toc = Toc.instance
			@toc.reset
			@toc.prepare items
		end

		it "walks correctly" do
			@toc.subsections(:lectures) do |subsection|
				expect(subsection[0]).to eq("")
				expect(subsection[1].class).to eq Array
				expect(subsection[1].length).to eq 4
			end
		end
	end

	describe "more complicated subsection structure" do
		let(:items) { MockItem.gen(
			 		%w(/lectures/hypotheses/ /lectures/ideation/
			 		/lectures/lean_immersion/welcome/
			 		/lectures/lean_startup/) ) }
		before (:each) do
			@toc = Toc.instance
			@toc.reset
			@toc.prepare items
		end

		it "walks correctly" do
	 		section_names = []
	 		section_sizes = []
			@toc.subsections(:lectures) do |subsection|
				section_names << subsection[0]
				section_sizes << subsection[1].length
			end
			expect(section_names).to eq(["", "lean_immersion"])
			expect(section_sizes).to eq([3, 1])
		end
	end

end
	
