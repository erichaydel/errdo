class StaticController < ApplicationController

  def home
  end

  def generic_error
    raise "standard-error"
  end

  def long_error
    raise "e" * 256
  end

  def deep_error
    eval(params[:code])
    render :home
  end

  def log
    Errdo.error "This is the error", user: current_user, data: "This is the data"
  end

  def double_render_error
    render :home
    render :log
  end

  def post_error
    raise "Error"
  end

  def extremely_long_error
    raise %Q(PG::UndefinedTable: ERROR: invalid reference to FROM-clause entry for table "organizations" LINE 1: ...arch_id WHERE "invoices"."deleted_at" IS NULL AND "organizat... ^ HINT: Perhaps you meant to reference the table alias "organizations_invoices". : SELECT "invoices".* FROM "invoices" INNER JOIN "organizations" "organizations_invoices" ON "organizations_invoices"."id" = "invoices"."organization_id" AND "organizations_invoices"."deleted_at" IS NULL INNER JOIN (SELECT "invoices"."id" AS pg_search_id, (ts_rank((to_tsvector('english', coalesce(pg_search_e64cbe24c80204e3d5e5c1.pg_search_97c188ecd05bd7fbff8e3c::text, ''))), (to_tsquery('english', ''' ' || 'pitchbook' || ' ''' || ':*') && to_tsquery('english', ''' ' || 'data' || ' ''' || ':*')), 0)) AS rank FROM "invoices" LEFT OUTER JOIN (SELECT "invoices"."id" AS id, string_agg("organizations"."name"::text, ' ') AS pg_search_97c188ecd05bd7fbff8e3c FROM "invoices" INNER JOIN "organizations" ON "organizations"."id" = "invoices"."organization_id" AND "organizations"."deleted_at" IS NULL GROUP BY "invoices"."id") pg_search_e64cbe24c80204e3d5e5c1 ON pg_search_e64cbe24c80204e3d5e5c1.id = "invoices"."id" WHERE (((to_tsvector('english', coalesce(pg_search_e64cbe24c80204e3d5e5c1.pg_search_97c188ecd05bd7fbff8e3c::text, ''))) @@ (to_tsquery('english', ''' ' || 'pitchbook' || ' ''' || ':*') && to_tsquery('english', ''' ' || 'data' || ' ''' || ':*'))) OR ((coalesce(pg_search_e64cbe24c80204e3d5e5c1.pg_search_97c188ecd05bd7fbff8e3c::text, '')) % 'pitchbook data') OR ((to_tsvector('simple', pg_search_dmetaphone(coalesce(pg_search_e64cbe24c80204e3d5e5c1.pg_search_97c188ecd05bd7fbff8e3c::text, '')))) @@ (to_tsquery('simple', ''' ' || pg_search_dmetaphone('pitchbook') || ' ''') && to_tsquery('simple', ''' ' || pg_search_dmetaphone('data') || ' '''))))) AS pg_search_491dabd42b00f84e105e30 ON "invoices"."id" = pg_search_491dabd42b00f84e105e30.pg_search_id WHERE "invoices"."deleted_at" IS NULL AND "organizations"."dummy_account" = 'f' ORDER BY pg_search_491dabd42b00f84e105e30.rank DESC, "invoices"."id" ASC)
  end

end
