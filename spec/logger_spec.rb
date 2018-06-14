require "spec_helper"

describe Discourse::DiscourseLogger do

  subject { Discourse::DiscourseLogger}

  it 'filters the message when it contains password' do
    expect_any_instance_of(TestLogger).to receive(:info)
                                      .with("[FILTERED]")
    subject.new.(:info, "try to log a password")
  end

end
