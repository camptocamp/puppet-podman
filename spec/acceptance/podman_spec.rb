require 'spec_helper_acceptance'

describe 'podman class' do
  describe 'when running puppet code' do
    let(:pp) do
      <<-MANIFEST
        class { 'podman': }
      MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(pp)
    end
  end

  context 'when running a container' do
    let(:pp) do
      <<-MANIFEST
        class { 'podman': }
        podman::run { 'redis_server':
          image => 'docker.io/redis',
        }
      MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      pending "I couldn't find a way to run podman in docker yet..."
      idempotent_apply(pp)
    end
  end
end
