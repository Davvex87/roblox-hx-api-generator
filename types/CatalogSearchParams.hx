package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("CatalogSearchParams")
extern abstract CatalogSearchParams(CatalogSearchParamsData) {}

@:native("CatalogSearchParams")
private extern class CatalogSearchParamsData
{
	function new();

	/**
	 * The keyword to search for catalog results with.
	 */
	@:native("SearchKeyword")
	var searchKeyword:String;

	/**
	 * The minimum item price to search for.
	 */
	@:native("MinPrice")
	var minPrice:Int;

	/**
	 * The maximum item price to search for.
	 */
	@:native("MaxPrice")
	var maxPrice:Int;

	/**
	 * The order in which to sort the results.
	 */
	@:native("SortType")
	var sortType:CatalogSortType;

	/**
	 * The time period to use to aggregate the sort results.
	 */
	@:native("SortAggregation")
	var sortAggregation:CatalogSortAggregation;

	/**
	 * The category to filter the search by.
	 */
	@:native("CategoryFilter")
	var categoryFilter:CatalogCategoryFilter;

	/**
	 * The sales type filter the search by.
	 */
	@:native("SalesTypeFilter")
	var salesTypeFilter:SalesTypeFilter;

	/**
	 * An array containing Enum.BundleType values to filter the search by.
	 */
	@:native("BundleTypes")
	var bundleTypes:Array<BundleType>;

	/**
	 * An array containing Enum.AvatarAssetType values to filter the search by.
	 */
	@:native("AssetTypes")
	var assetTypes:Array<AvatarAssetType>;

	/**
	 * Whether off sale items should be included in the results.
	 */
	@:native("IncludeOffSale")
	var includeOffSale:Bool;

	/**
	 * Search for items with the given creator name.
	 */
	@:native("CreatorName")
	var creatorName:String;

	/**
	 * Search for items created by the given creator type.
	 */
	@:native("CreatorType")
	var creatorType:CreatorTypeFilter;

	/**
	 * Search for items created by the given creator ID.
	 */
	@:native("CreatorId")
	var creatorId:Int;

	/**
	 * Specifies the number of items to return. Accepts 10, 28, 30, 60, and 120. Defaults to 30.
	 */
	@:native("Limit")
	var limit:Int;
}
