require 'spec_helper'

describe "1 - first group" do
  it "a1 - sets bad global state" do
    $global_state = true
    expect($global_state).to be_true
  end
end
