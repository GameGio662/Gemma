using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CrystalShaderController : MonoBehaviour
{
    public Material crystalMaterial;
    [Range(0, 1)] public float refraction = 0.02f;
    public Color rimColor = Color.white;
    [Range(1, 10)] public float rimPower = 3.0f;

    void Update()
    {
        if (crystalMaterial)
        {
            crystalMaterial.SetFloat("_Refraction", refraction);
            crystalMaterial.SetColor("_RimColor", rimColor);
            crystalMaterial.SetFloat("_RimPower", rimPower);
        }
    }
}
