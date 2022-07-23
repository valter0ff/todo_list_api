# frozen_string_literal: true

module Helpers
  module ContractHelper
    def define_contract_by_schema(schema, dependencies = {})
      Macro::Contract::BaseSchemaObject.Build(schema).new(schema, dependencies)
    end
  end
end
