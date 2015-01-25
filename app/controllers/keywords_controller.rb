class KeywordsController < ApplicationController
  def index
    if params[:query]
      query = "%#{params[:query]}%"
      @keywords = Keyword.where("name LIKE ?", query)
        .limit(params[:limit]).offset(params[:offset])
      count = Keyword.where("name LIKE ?", query).count
    else
      @keywords = Keyword.all.limit(params[:limit]).offset(params[:offset])
      count = Keyword.all.count
    end
    render json: {status: "success", keywords: @keywords, count: count}
  end

  def show
    id = params[:id]
    if id.to_i.to_s == id
      @keyword = Keyword.find(id)
      @records = @keyword.records
      count = @records.length
    else
      query = "%#{id}%"
      @records = Record.query_keywords(query).limit(params[:limit]).offset(params[:offset])
      count = Record.query_keywords(query).length
    end
    if @records
      render json: {status: "success", records: filter_records(@records), count: count}
    else
      render json: {status: "failed", error: "not found"}
    end
  end
end
