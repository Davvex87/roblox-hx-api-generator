package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("PhysicalProperties")
extern abstract PhysicalProperties(PhysicalPropertiesData) {}

@:native("PhysicalProperties")
private extern class PhysicalPropertiesData
{
	/**
	 * Returns a PhysicalProperties with the default properties for the given material.
	 */
	@:native("new")
	static function fromMaterial(material:Material):PhysicalProperties;

	/**
	 * Creates a PhysicalProperties container with the specified density, friction, elasticity, weight of friction, and weight of elasticity.
	 */
	function new(density:Float, friction:Float, elasticity:Float, frictionWeight:Float, elasticityWeight:Float);

	/**
	 * A value between 0 and 1 denoting how absorbent the material is to AudioEmitters.
	 */
	@:native("AcousticAbsorption")
	var acousticAbsorption:Float;

	/**
	 * The mass per unit volume of the part.
	 */
	@:native("Density")
	var density:Float;

	/**
	 * The deceleration of the part when rubbing against another part.
	 */
	@:native("Friction")
	var friction:Float;

	/**
	 * The amount of energy retained when colliding with another part.
	 */
	@:native("Elasticity")
	var elasticity:Float;

	/**
	 * The importance of the part's Friction property when calculating the friction with the colliding part.
	 */
	@:native("FrictionWeight")
	var frictionWeight:Float;

	/**
	 * The importance of the part's Elasticity property when calculating the elasticity with the colliding part.
	 */
	@:native("ElasticityWeight")
	var elasticityWeight:Float;
}
