require 'spec_helper'

describe UsersController do
  describe "#update" do
    let(:user) { FactoryGirl.create(:persona_user) }

    it "should update the user's profile" do
      updates = {id: user.id, user: {display_name: "New Name", hide_avatar: true, hide_url: true}}
      post :update, updates
      User.last.display_name.should == "New Name"
      User.last.hide_avatar.should == true
      User.last.hide_url.should == true
    end

    it "should only allow updates to allowed fields" do
      updates = {id: user.id, user: {display_name: "New Name 2", hide_avatar: false, hide_url: true, is_admin: true, up_votes: 12}}
      post :update, updates
      User.last.display_name.should == "New Name 2"
      User.last.hide_avatar.should be_false
      User.last.hide_url.should be_true

      User.last.is_admin.should_not be_true
      User.last.up_votes.should == 0
    end

  end
end
