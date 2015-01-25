class RecordsController < ApplicationController
  def show
    id = params[:id]
    if id.to_i.to_s == id
      @record = Record.find(id)
    else
      @record = Record.find({identifier: id})
    end
    if @record
      render json: {status: "success", record: filter_record(@record)}
    else
      render json: {status: "failed", error: "not found"}
    end
  end

  def index
    if params[:query]
      query = "%#{params[:query]}%"
      @records = Record.where("title LIKE ? OR catalog LIKE ? OR content LIKE ?", query, query, query)
        .limit(params[:limit]).offset(params[:offset])
      count = Record.where("title LIKE ? OR catalog LIKE ? OR content LIKE ?", query, query, query).count
    else
      @records = Record.all.limit(params[:limit]).offset(params[:offset])
      count = Record.all.count
    end
    render json: {status: "success", records: filter_records(@records), count: count}
  end

  private

end
