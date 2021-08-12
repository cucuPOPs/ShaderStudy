using UnityEngine;
using UnityEngine.Rendering;
using UnityEditor;
using UnityEditor.SceneManagement;
using System.Linq;
using System;

public class MyShader : ShaderGUI
{
    private Material targetMat;
    private GUIStyle style, bigLabelStyle, smallLabelStyle;
    private const int bigFontSize = 16, smallFontSize = 11;
    private string[] oldKeyWords;
    private int effectCount = 1;
    private Material originalMaterialCopy;
    private MaterialEditor matEditor;
    private MaterialProperty[] matProperties;

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        //변수 초기화
        matEditor = materialEditor;
        matProperties = properties;
        targetMat = materialEditor.target as Material;
        effectCount = 1;
        oldKeyWords = targetMat.shaderKeywords;
        style = new GUIStyle(EditorStyles.helpBox);
        style.margin = new RectOffset(0, 0, 0, 0);
        bigLabelStyle = new GUIStyle(EditorStyles.boldLabel);
        bigLabelStyle.fontSize = bigFontSize;
        smallLabelStyle = new GUIStyle(EditorStyles.boldLabel);
        smallLabelStyle.fontSize = smallFontSize;

        //
        DrawProperty(0);
        DrawLine(Color.grey, 1, 3);
        //
        GUILayout.Label("Select Effect", bigLabelStyle);
        DrawToggle("Glow", "GLOW_ON", () => { DrawProperty(1); DrawProperty(2); });
        DrawToggle("Negative", "NEGATIVE_ON", () => { DrawProperty(3); });
        DrawToggle("greyscale", "GREYSCALE_ON", () => { DrawProperty(4); });
        //
        DrawLine(Color.grey, 1, 3);
        materialEditor.RenderQueueField();
    }

    private void DrawToggle(string inspectorDisplayName, string shaderKeyword, Action action)
    {
        bool toggle = oldKeyWords.Contains(shaderKeyword);
        bool ini = toggle;

        GUIContent effectNameLabel = new GUIContent();
        effectNameLabel.text = effectCount + "." + inspectorDisplayName;
        toggle = EditorGUILayout.BeginToggleGroup(effectNameLabel, toggle);

        effectCount++;
        if (ini != toggle && !Application.isPlaying)
            EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        if (toggle)
        {
            targetMat.EnableKeyword(shaderKeyword);
            EditorGUILayout.BeginVertical(style);
            {
                action();
            }
            EditorGUILayout.EndVertical();
        }
        else targetMat.DisableKeyword(shaderKeyword);

        EditorGUILayout.EndToggleGroup();
    }
    private void DrawProperty(int index, bool noReset = false)
    {
        MaterialProperty targetProperty = matProperties[index];

        EditorGUILayout.BeginHorizontal();
        {
            GUIContent propertyLabel = new GUIContent();
            propertyLabel.text = targetProperty.displayName;

            matEditor.ShaderProperty(targetProperty, propertyLabel);

            if (!noReset)
            {
                GUIContent resetButtonLabel = new GUIContent();
                resetButtonLabel.text = "R";
                if (GUILayout.Button(resetButtonLabel, GUILayout.Width(20))) ResetProperty(targetProperty);
            }
        }
        EditorGUILayout.EndHorizontal();
    }

    private void ResetProperty(MaterialProperty targetProperty)
    {
        if (originalMaterialCopy == null) originalMaterialCopy = new Material(targetMat.shader);
        if (targetProperty.type == MaterialProperty.PropType.Float ||
            targetProperty.type == MaterialProperty.PropType.Range)
        {
            targetProperty.floatValue = originalMaterialCopy.GetFloat(targetProperty.name);
        }
        else if (targetProperty.type == MaterialProperty.PropType.Color)
        {
            targetProperty.colorValue = originalMaterialCopy.GetColor(targetProperty.name);
        }
    }

    private void DrawLine(Color color, int thickness = 2, int padding = 10)
    {
        Rect r = EditorGUILayout.GetControlRect(GUILayout.Height(padding + thickness));
        r.height = thickness;
        r.y += (padding / 2);
        r.x -= 2;
        r.width += 6;
        EditorGUI.DrawRect(r, color);
    }
}