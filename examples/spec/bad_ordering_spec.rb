require 'spec_helper'

describe "Tests that fail when run in a specific order" do
  it "leaves bad global state" do
    $fail_next = true
    expect($fail_next).to be_true
  end

  it "just takes up space" do
    expect(true).to be_true
  end

  it "fails when run last" do
    expect($fail_next).to be_false
  end
end
