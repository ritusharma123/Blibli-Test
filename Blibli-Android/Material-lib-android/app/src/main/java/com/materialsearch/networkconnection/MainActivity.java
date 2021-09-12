package com.materialsearch.networkconnection;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.curiosearch.materiall.ProductRecommendationSearch;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class MainActivity extends Activity {
    Button confirm_button;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        confirm_button = findViewById(R.id.confirm_button);
        confirm_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                /////////////getRecommendedProductCategory/////////////
                try {
                    ProductRecommendationSearch productRecommendationSearch1 = new ProductRecommendationSearch();

                    productRecommendationSearch1.setCount(8);
                    productRecommendationSearch1.setSortBy("Relevance");
                    productRecommendationSearch1.setCategoryId("54817");
                    productRecommendationSearch1.setSearchq("polycotton t shirt");
                    productRecommendationSearch1.setXRequestID("123");
                    productRecommendationSearch1.setFilter("color_matFilter:Red OR color_matFilter:Blue");

                    JSONObject result = productRecommendationSearch1.getRecommendedProductCategory("blibli-client2", "xyz-xyz-xyz", "categoryPage", "ses-xuz-abc", "blibli", "2");
                    if (result != null) {
                        System.out.println("productCategoryresponse :   " + result);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }


                ///////////////getRecordUserActions///////////////////
                try {

                    ProductRecommendationSearch productRecommendationSearch2 = new ProductRecommendationSearch();

                    productRecommendationSearch2.setXRequestID("123");
                    productRecommendationSearch2.setCategoryId("54817");
                    productRecommendationSearch2.setSearchq("Pakaian dresses");
                    productRecommendationSearch2.setRatings(4.5f);

                    JSONObject productList = new JSONObject();
                    JSONArray jsonArray = new JSONArray();
                    JSONObject obj1 = new JSONObject();
                    JSONObject obj2 = new JSONObject();

                    try {
                        obj1.put("id", "RAS-60191-00081-00003");
                        obj2.put("id", "BLS-60040-58802-00002");

                        obj1.put("sku", "RAS-60191-00081");
                        obj2.put("sku", "BLS-60040-58802");

                        obj1.put("merchantId", "RAS-60191");
                        obj2.put("merchantId", "BLS-60040");

                        obj1.put("merchantname", "RAGGAKIDS");
                        obj2.put("merchantname", "Bluelans");

                        obj1.put("campaign_id", "campaign_CAMP-00553_153736");
                        obj2.put("campaign_id", "campaign_CAMP-00553_153736");

                        obj1.put("position", 1);
                        obj2.put("position", 2);

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    jsonArray.put(obj1);
                    jsonArray.put(obj2);

                    productList.put("products", jsonArray);
                    System.out.println("jsonObjectResponse :   " + " " + productList);

                    JSONObject result = productRecommendationSearch2.recordUserActions( "xyz-xyz-xyz", "blibli-client2", "ses-xuz-abc", "rate","desktop", "linux", "Chrome", "searchPage", "3", productList);
                    if (result != null) {
                        System.out.println("getRecordUserActionsResponse :   " + result);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        });
    }
}
