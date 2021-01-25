class RecordsController < ApplicationController
  before_action :validate_dns_records, only: :create
  before_action :validate_query, only: :index

  def index
    records = Record.custom_filter(params[:included], params[:excluded])
    related_hostnames = Hostname
      .filter_related_hostnames(params[:included], params[:excluded])
      .map{ |h| h.address }
      .tally

    render json: {
      total_records: records.length,
      records: records.map { |r| { id: r.id, ip_address: r.ip } },
      related_hostnames: related_hostnames.map { |h, c| { hostname: h, count: c } }
    }
  end

  def create
    record_ip = params[:dns_records][:ip]
    record = Record.find_or_create_by(ip: record_ip)
    params[:dns_records][:hostnames_attributes].each do |entry|
      hostname = Hostname.find_or_create_by(address: entry[:hostname])
      record.hostnames << hostname
    end

    render json: { id: record.id }
  end

  private

  def validate_query
    validator_valid = params[:page].present? && params[:page].to_i > 0

    return if validator_valid

    render json: { errors: "invalid query" }, status: 400
  end

  def validate_dns_records
    validator_valid = params[:dns_records].present? &&
      params[:dns_records][:ip].present? &&
      params[:dns_records][:hostnames_attributes].present? &&
      params[:dns_records][:hostnames_attributes].all? { |hostname_attribute| hostname_attribute.key?(:hostname) }

    return if validator_valid

    render json: { errors: "invalid dns_records" }, status: 422
  end
end
