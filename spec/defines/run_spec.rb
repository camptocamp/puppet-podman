require 'spec_helper'

describe 'podman::run' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      image: 'centos:8',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
