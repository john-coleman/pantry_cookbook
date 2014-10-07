RSpec.describe 'pantry::rubygems' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['pantry']['rubygems']['username'] = username
      node.set['pantry']['rubygems']['password'] = password
      node.set['pantry']['rubygems']['rubygems_host'] = 'https://other-rubygems.org'
      node.set['pantry']['rubygems']['set_push_credentials'] = set_push_credentials
      node.set['pantry']['user'] = ENV['USER']
    end.converge(described_recipe)
  end

  let(:username) { nil }
  let(:password) { nil }
  let(:set_push_credentials) { false }

  context 'when username and password are sets' do
    let(:username) { 'username' }
    let(:password) { 'password' }

    it 'adds gem source with username and password' do
      expect(chef_run).to run_bash('Add gem source').with(code: 'bundle config https://other-rubygems.org/ username:password')
    end

    context 'when push is allowed' do
      let(:set_push_credentials) { true }

      it 'sets ENV variable' do
        expect(chef_run).to create_template('/etc/profile.d/rubygems.sh').with(variables: { host: 'https://other-rubygems.org' })
      end

      it 'gets credentials' do
        expect(chef_run.template('/etc/profile.d/rubygems.sh')).to notify('bash[Set credentials]').to(:run)
      end
    end
  end

  context 'when push is allowed' do
    let(:set_push_credentials) { true }

    it "doesn't set anything" do
      expect(chef_run).not_to run_bash('Set credentials')
    end
  end
end
