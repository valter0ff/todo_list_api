# frozen_string_literal: true

module DefaultEndpoint
  def default_cases
    {
      created: ->(result) { result.success? && result[:semantic_success] == :created },
      unauthorized: ->(result) { result.failure? && result[:semantic_failure] == :unauthorized },
      not_found: ->(result) { result.failure? && result[:semantic_failure] == :not_found },
      forbidden: ->(result) { result.failure? && result[:semantic_failure] == :forbidden },
      invalid: ->(result) { result.failure? && find_contract(result)&.errors.present? },
      destroyed: ->(result) { result.success? && result[:semantic_success] == :destroyed },
      ok: ->(result) { result.success? && result[:semantic_success] == :ok },
      success: ->(result) { result.success? }
    }
  end

  def default_handler
    {
      created: ->(result) { render_success_response(result, :created) },
      unauthorized: ->(result) { render_invalid_response(result, :unauthorized) },
      forbidden: ->(result) { render_invalid_or_head(result, :forbidden) },
      invalid: ->(result) { render_invalid_response(result, :unprocessable_entity) },
      success: ->(result) { render_success_response(result, :no_content) },
      destroyed: ->(result) { render_success_response(result, :no_content) },
      ok: ->(result) { render_success_response(result, :ok) },
      not_found: ->(result) { render_invalid_or_head(result, :not_found) }
    }
  end

  private

  def find_contract(result)
    name = result[:contract_name]
    return result['contract.default'] unless name

    custom_contract = result["contract.#{name}"]
    custom_contract&.errors.present? ? custom_contract : result['contract.default']
  end

  def render_invalid_or_head(result, status)
    find_contract(result)&.errors.present? ? render_invalid_response(result, status) : head(status)
  end

  def render_invalid_response(result, status)
    render json: { errors: find_contract(result).errors.messages }, status: status
  end

  def render_success_response(result, status)
    result[:serializer] ? render(json: result[:serializer].serializable_hash, status: status) : head(status)
  end
end
