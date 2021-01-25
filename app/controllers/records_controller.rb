class RecordsController < ApplicationController
  before_action :validate_dns_records, only: :create

  def create
    record_ip = params[:dns_records][:ip]
    record = Record.find_or_create_by(ip: record_ip)
    params[:dns_records][:hostnames_attributes].each do |entry|
      record.hostnames.find_or_create_by(address: entry[:hostname])
    end

    render json: { id: record.id }
  end

  private

  def validate_dns_records
    validator_valid = params[:dns_records].present? &&
      params[:dns_records][:ip].present? &&
      params[:dns_records][:hostnames_attributes].present? &&
      params[:dns_records][:hostnames_attributes].all? { |hostname_attribute| hostname_attribute.key?(:hostname) }

    return if validator_valid

    render json: { errors: "invalid dns_records" }, status: 422
  end
end
