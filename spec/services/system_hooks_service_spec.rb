require 'spec_helper'

describe SystemHooksService do
  let (:user)          { create :user }
  let (:project)       { create :project }
  let (:project_member) { create :project_member }
  let (:key)           { create(:key, user: user) }
  let (:group)         { create(:group) }
  let (:group_member)  { create(:group_member) }

  context 'event data' do
    it { event_data(user, :create).should include(:event_name, :name, :created_at, :email, :user_id) }
    it { event_data(user, :destroy).should include(:event_name, :name, :created_at, :email, :user_id) }
    it { event_data(project, :create).should include(:event_name, :name, :created_at, :path, :project_id, :owner_name, :owner_email, :project_visibility) }
    it { event_data(project, :destroy).should include(:event_name, :name, :created_at, :path, :project_id, :owner_name, :owner_email, :project_visibility) }
    it { event_data(project_member, :create).should include(:event_name, :created_at, :project_name, :project_path, :project_id, :user_name, :user_email, :access_level, :project_visibility) }
    it { event_data(project_member, :destroy).should include(:event_name, :created_at, :project_name, :project_path, :project_id, :user_name, :user_email, :access_level, :project_visibility) }
    it { event_data(key, :create).should include(:username, :key, :id) }
    it { event_data(key, :destroy).should include(:username, :key, :id) }

    it do
      event_data(group, :create).should include(
        :event_name, :name, :created_at, :path, :group_id, :owner_name,
        :owner_email
      )
    end
    it do
      event_data(group, :destroy).should include(
        :event_name, :name, :created_at, :path, :group_id, :owner_name,
        :owner_email
      )
    end
    it do
      event_data(group_member, :create).should include(
        :event_name, :created_at, :group_name, :group_path, :group_id, :user_id,
        :user_name, :user_email, :group_access
      )
    end
    it do
      event_data(group_member, :destroy).should include(
        :event_name, :created_at, :group_name, :group_path, :group_id, :user_id,
        :user_name, :user_email, :group_access
      )
    end
  end

  context 'event names' do
    it { event_name(user, :create).should eq "user_create" }
    it { event_name(user, :destroy).should eq "user_destroy" }
    it { event_name(project, :create).should eq "project_create" }
    it { event_name(project, :destroy).should eq "project_destroy" }
    it { event_name(project_member, :create).should eq "user_add_to_team" }
    it { event_name(project_member, :destroy).should eq "user_remove_from_team" }
    it { event_name(key, :create).should eq 'key_create' }
    it { event_name(key, :destroy).should eq 'key_destroy' }
    it { event_name(group, :create).should eq 'group_create' }
    it { event_name(group, :destroy).should eq 'group_destroy' }
    it { event_name(group_member, :create).should eq 'user_add_to_group' }
    it { event_name(group_member, :destroy).should eq 'user_remove_from_group' }
  end

  def event_data(*args)
    SystemHooksService.new.send :build_event_data, *args
  end

  def event_name(*args)
    SystemHooksService.new.send :build_event_name, *args
  end
end
