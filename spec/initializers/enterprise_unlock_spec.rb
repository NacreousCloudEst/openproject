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

require "spec_helper"

RSpec.describe EnterpriseUnlock do
  describe ".enabled?" do
    it "is off by default in the test environment" do
      expect(described_class).not_to be_enabled
    end

    it "is on when OPENPROJECT_ENTERPRISE_UNLOCK is true", with_env: { "OPENPROJECT_ENTERPRISE_UNLOCK" => "true" } do
      expect(described_class).to be_enabled
    end
  end

  describe EnterpriseUnlock::ClassMethods do
    subject(:unlocked) do
      klass = Class.new do
        def self.available_features = Set[:token_only_feature]
      end
      klass.singleton_class.prepend(described_class)
      klass
    end

    it "allows every feature without a token" do
      expect(unlocked.allows_to?(:anything)).to be(true)
    end

    it "exposes the known features plus those of any real token" do
      expect(unlocked.available_features).to include(:custom_field_hierarchies, :sso_auth_providers, :token_only_feature)
    end

    it "reports active, not trialling, with banners hidden" do
      expect(unlocked).to be_active
      expect(unlocked).not_to be_trialling(:custom_actions)
      expect(unlocked.trialling_features).to be_empty
      expect(unlocked.hide_banners?).to be(true)
    end
  end
end
