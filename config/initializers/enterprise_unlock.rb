# frozen_string_literal: true

#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# See COPYRIGHT and LICENSE files for more details.
#++

module EnterpriseUnlock
  FEATURES = %i[
    baseline_comparison
    board_view
    calculated_values
    capture_external_links
    custom_actions
    custom_field_hierarchies
    customize_life_cycle
    define_custom_style
    edit_attribute_groups
    gantt_pdf_export
    internal_comments
    ldap_groups
    mcp_server
    meeting_templates
    multiple_active_sprints
    nextcloud_sso
    one_drive_sharepoint_file_storage
    placeholder_users
    portfolio_management
    project_creation_wizard
    project_list_sharing
    readonly_work_packages
    resource_management
    scim_api
    sprint_sharing
    sso_auth_providers
    team_planner_view
    time_entry_time_restrictions
    virus_scanning
    weighted_item_lists
    work_package_query_relation_columns
    work_package_sharing
    work_package_subject_generation
    xwiki_integration
  ].to_set.freeze

  def self.enabled?
    default = Rails.env.test? ? "false" : "true"
    ActiveModel::Type::Boolean.new.cast(ENV.fetch("OPENPROJECT_ENTERPRISE_UNLOCK", default))
  end

  module ClassMethods
    def allows_to?(_feature) = true

    def active? = true

    def available_features = FEATURES | super

    def trialling_features = Set.new

    def trialling?(_feature) = false

    def hide_banners? = true
  end
end

Rails.application.config.to_prepare do
  EnterpriseToken.singleton_class.prepend(EnterpriseUnlock::ClassMethods) if EnterpriseUnlock.enabled?
end
