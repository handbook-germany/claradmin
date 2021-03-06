# frozen_string_literal: true

module SyncWithDivisions
  def syncronize_done_state(_, model:, current_user:, **)
    if model.approved? || model.all_done?
      mark_as_done_or_approved model, current_user
    end
    true
  end

  private

  def mark_as_done_or_approved orga, current_user
    all_divisions_done =
      orga.divisions.any? && orga.divisions.where(done: false).empty?
    if orga.approved? && all_divisions_done
      orga.mark_as_done! # trigger event for callbacks
      ::Assignment::CreateBySystem.(
        {}, assignable: orga, last_acting_user: current_user
      ).success?
    elsif orga.all_done? && !all_divisions_done
      orga.update_columns(aasm_state: 'approved')
    end
  end
end
