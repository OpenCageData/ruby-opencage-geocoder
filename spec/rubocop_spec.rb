require File.expand_path 'spec_helper.rb', __dir__

describe 'Ruby linting', type: :feature do
  it 'run rubocop' do
    expect do
      system('bundle exec rubocop --no-color --format simple 2>&1')
    end.to output(/no offenses detect/).to_stdout_from_any_process
  end
end
