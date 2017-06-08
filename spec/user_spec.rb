require 'user'

RSpec.describe User do
  before do
    DataMapper.setup(:default, 'postgres://pizzabuddy@localhost/pizzabuddytest')
    DataMapper.finalize
    User.auto_migrate!
  end

  describe '.authenticate' do
    let(:amazon_response) do
      amazon_response = {
        name: "Timmy Tales"
      }.to_json
    end
    let(:client) { double(:"Net::HTTP", get: amazon_response) }

    it 'creates a user if one does not exist' do
      expect { User.authenticate("AccessToken", client) }.to change { User.count }.by(1)
    end

    it 'retrieves a user if a one with that name and access token does exist' do
      User.create(name: "Timmy", access_token: "AccessToken")

      expect { User.authenticate("AccessToken", client) }.not_to change { User.count }
      expect(User.authenticate("AccessToken", client).name).to eq "Timmy"
      expect(User.authenticate("AccessToken", client).access_token).to eq "AccessToken"
    end
  end

  describe 'Saving to a database' do
    it 'starts out unpersisted' do
      user = User.new
      expect(user.id).to be_nil
    end

    it 'can be persisted' do
      user = User.new(name: "Timmy", access_token: "AccessToken")
      user.save

      persisted_user = User.last
      expect(persisted_user.id).not_to be_nil
      expect(persisted_user.name).to eq "Timmy"
      expect(persisted_user.access_token).to eq "AccessToken"
    end
  end
end