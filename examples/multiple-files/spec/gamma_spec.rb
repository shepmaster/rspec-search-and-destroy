require 'spec_helper'

describe "3 - third group" do
  it "3a - fails because of global state" do
    expect($global_state).to be_false
  end
end
