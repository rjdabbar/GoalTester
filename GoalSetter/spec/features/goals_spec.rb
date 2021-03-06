require 'spec_helper'
require 'rails_helper'

feature "goal creation" do


  it "has a link to new goal" do
    sign_up("Sennacy")
    visit "/goals/"
    expect(page).to have_content "Create New Goal"
  end

  feature "creating a goal" do
    before :each do
      sign_in_as_test_user
      click_link "Create New Goal"
    end

    it "allows text of goal" do
      expect(page).to have_content "Text"
    end

    it "can be set to private" do
      expect(page).to have_content "Private"
    end

    it "ensures that goal has text" do
      click_button "Add New Goal"
      expect(page).to have_content "Text can't be blank"
    end
  end

  feature "editing a goal" do
    before :each do
      sign_in_as_test_user
      make_private_goal
      click_link "Edit Goal"
    end

    it "prepopulates the data for a goal" do
      expect(page).to have_content "test private goal"
      expect(page).to have_checked_field "Private"
    end

    it "allows text to be changed" do
      fill_in "Text", with: "test edited text"
      click_button "Update Goal"
      expect(page).to have_content "test edited text"
    end

    it "allows privacy of goal to be changed" do
      choose "Public"
      click_button "Update Goal"
      expect(page).to have_content "Public"
    end
  end

  feature "deleting a goal" do
    before :each do
      sign_in_as_test_user
      make_private_goal
    end

    it "can be done from index page or show page" do
      expect(page).to have_content "Delete Goal"
      visit "/goals/"
      expect(page).to have_content "Delete Goal"
    end

    it "deletes selected goal" do
      click_button "Delete Goal"
      expect(page).not_to have_content "test private goal"
    end

    it "shows the goal index on click" do
      click_button "Delete Goal"
      expect(page).to have_content "All Goals"
    end

  end

  feature "viewing all goals" do
    before :each do
      sign_in_as_test_user
      make_private_goal
      visit "/goals/"
      make_public_goal
      sign_out
      sign_up("Sennacy")
      visit "/goals/"
      make_public_goal
      visit "/goals/"
      make_custom_private_goal("SECRET")
    end

    it "all public goals should be shown" do
      expect(page).not_to have_content "test private goal"
    end

    it "only the current user's private goals should be shown" do
      expect(page).not_to have_content "test private goal"
      expect(page).to have_content "SECRET"
    end
  end

  feature "viewing user's goals" do
    before :each do
      sign_in_as_test_user
      make_private_goal
      visit "/goals/"
      make_public_goal
      sign_out
      sign_up("Sennacy")
      visit "/goals/"
      make_public_goal
      visit "/goals/"
      make_custom_private_goal("SECRET")
    end

    it "only the user's public goals are visilbe" do
      visit "/users/1"
      expect(page).to have_content "test public goal"
      expect(page).not_to have_content "test private goal"
    end

    it "current user can see their private and public goals" do
      visit "/users/2"
      expect(page).to have_content "test public goal"
      expect(page).to have_content "SECRET"
    end
  end
end

feature "goal completion" do
  before :each do
    sign_up("Sennacy")
    visit "/goals/"
    make_private_goal
  end

  it "starts with uncompleted goals" do
    expect(page).not_to have_content "Completed"
  end

  it "moves completed goals to Completed section" do
    visit "/users/1"
    click_button "Complete Goal"
    expect(page).to have_content "Completed"
  end



end
