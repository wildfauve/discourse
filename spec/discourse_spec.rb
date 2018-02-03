require "spec_helper"
require 'discourse/version'

describe Discourse do
  it "has a version number" do
    expect(Discourse::VERSION).not_to be nil
  end

end
