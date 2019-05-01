require "test_helper"

describe Category do

  it "must be valid" do
    value(categories(:oneway)).must_be :valid?
  end

end
