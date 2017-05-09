require 'pizza'

RSpec.describe Pizza do
  describe 'SIZES' do
    it 'holds the available pizza sizes' do
      expect(described_class::SIZES).to eq [:small, :medium, :large]
    end
  end
end