# frozen_string_literal: true

module Macro
  def self.ContractErrors(error: nil, **)
    task = Trailblazer::Activity::TaskBuilder::Binary(
      lambda { |ctx, **|
        return true if ctx['contract.default'].errors.present?
      
        ctx['contract.default'].errors.messages[:base] = I18n.t('errors.unprocessable')
        true
      }
    )
    { task: task, id: "#{name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end 
