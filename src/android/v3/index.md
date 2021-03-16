---
title: MapsIndoors Android SDK v3
eleventyNavigation:
  parent: index
  key: android-v3
  title: Android v3
---

This guide explains how to start using a MapsIndoors map in your Android application using the MapsIndoors Android SDK v3.

To benefit from the guides, you will need basic knowledge about:

* Android Development
* Google Maps Android API

You can get started in two ways, either by reviewing and modifying the [basic example](#basic-example) or do the [clean setup](#setup-mapsindoors).

## Basic Example

You will find in the [link](https://github.com/MapsIndoors/MapsIndoorsAndroid-Demo-Samples/) a repo that contains the minimum code to start a MapsIndoors project.

You can also follow the steps below to start your app from scratch or to enhance the Basic Examples, more features will be explained in the [guides](/android/v3/guides/).

## Setup MapsIndoors

Add the MapsIndoors SDK as a dependency to your project. The AAR for the MapsIndoors SDK contains both Java classes, SDK resources and AndroidManifest.xml template which gets merged into your application's AndroidManifest.xml during build process. Add or merge in the following to your app's build gradle file (usually called build.gradle).

Make sure that the minimum Android SDK version is 21 (aka. "Android Lollipop", version 5.0) or above:

```java
android {
    defaultConfig {
        minSdkVersion 21
    }
    ...
}
```

MapsIndoors rely on Java 8 features, so you must add the following compile options, also in *android* section of your *build.gradle* file:

```java
android {
    ...
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```

Add the following dependencies and the MapsIndoors maven repository:

```java
dependencies {
    ...
    implementation 'com.android.support:support-v4:27.1.0'
    implementation 'com.google.android.gms:play-services-maps:11.8.0'
    implementation 'com.google.code.gson:gson:2.8.6'
    implementation 'com.mapspeople.mapsindoors:mapsindoorssdk:3.8.2'
}
repositories{
    maven {
        url 'http://maven.mapsindoors.com/'
    }
}
```

Put those lines in your proguard-rules files :

```java
-keep interface com.mapsindoors.mapssdk.** { *; }
-keep class com.mapsindoors.mapssdk.errors.** { *; }
-keepclassmembers class com.mapsindoors.mapssdk.models.** { <fields>; }
-keep class com.mapsindoors.mapssdk.dbglog
```

Sync your project with gradle files.

## Setup Google Maps

Learn how to setup Google Maps on Android in this [Getting Started Guide](https://developers.google.com/maps/documentation/android-api/start).

Some Web Service APIs are needed also for the MapsIndoors SDK, so make sure to enable them when getting your key:

* [Google Maps Distance Matrix API](https://developers.google.com/maps/documentation/distance-matrix/start)
* [Google Maps Directions API](https://developers.google.com/maps/documentation/directions/start)
* [Google Places API Web Service](https://developers.google.com/places/web-service/intro)

When getting your Google Maps API keys, remember to enable relevant Maps products (i.e. SDK for Android) in your Google project and include these on your API key if you apply restrictions.

## Setup a Google Map with MapsIndoors

### Set the MapsIndoors API Key

In order to include MapsIndoors in your app, you need an API key. If you are not a customer you can use this API key `79f8e7daff76489dace4f9f9` to follow the guide.

In order to include MapsIndoors in your own app with your own content, you need to [contact MapsPeople](https://resources.mapspeople.com/contact-us) to get your building drawings processed and hosted by us.

You will receive a unique API key to use when access has been granted. If you are exploring how this service can become part of your own product, you can read about [partnering with MapsPeople here](https://www.mapspeople.com/become-a-partner).

### Initialize MapsIndoors

Place the following initialization code in the `onCreate` method in the activity that should display the Google map:

<mi-tabs>
    <mi-tab label="Java" tab-for="java"></mi-tab>
    <mi-tab label="Kotlin" tab-for="kotlin"></mi-tab>
    <mi-tab-panel id="java">
        <h3>Java</h3>
        <pre lang="Java"><code>
MapsIndoors.initialize(getApplicationContext(), "YOUR_MAPSINDOORS_API_KEY");
MapsIndoors.setGoogleAPIKey(“YOUR_GOOGLE_API_KEY”);
        </code></pre>
    </mi-tab-panel>
    <mi-tab-panel id="kotlin">
        <h3>Kotlin</h3>
        <pre lang ="Kotlin"><code>
MapsIndoors.initialize(applicationContext, "YOUR_MAPSINDOORS_API_KEY")
MapsIndoors.setGoogleAPIKey(“YOUR_GOOGLE_API_KEY”)
        </code></pre>
    </mi-tab-panel>
</mi-tabs>

In your `onMapReady` callback function, use the `MapControl` class to set up a Google map with MapsIndoors venues, buildings & locations:

<mi-tabs>
    <mi-tab label="Java" tab-for="java"></mi-tab>
    <mi-tab label="Kotlin" tab-for="kotlin"></mi-tab>
    <mi-tab-panel id="java">
        <h3>Java</h3>
        <pre lang="Java"><code>
@Override
public void onMapReady(GoogleMap googleMap) {
   mMap = googleMap;
   if (view != null) {
       initMapControl(view);
   }
}
void initMapControl(View view) {
   mMapControl = new MapControl(getApplicationContext());
   mMapControl.setGoogleMap(mMap, view);
   mMapControl.init(miError -> {
       if (miError == null) {
           runOnUiThread( ()-> {
               mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(new   LatLng(38.8975552046, -77.036568326), 19f));
           });
       }
   });
}
        </code></pre>
    </mi-tab-panel>
    <mi-tab-panel id="kotlin">
        <h3>Kotlin</h3>
        <pre lang ="Kotlin"><code>
override fun onMapReady(googleMap: GoogleMap) {
   mMap = googleMap
   map.view?.let {
       initMapControl(it)
   }
}
fun initMapControl(view: View) {
   mMapControl = MapControl(applicationContext)
   mMapControl.setGoogleMap(mMap, view)
   mMapControl.init { error ->
       if (error == null) {
           runOnUiThread {
               mMap.animateCamera(
                       CameraUpdateFactory.newLatLngZoom(LatLng(38.8975552046, -77.036568326), 19f))
           }
       }
   }
}
        </code></pre>
    </mi-tab-panel>
</mi-tabs>

Head to the [guides]({{ site.url }}/android/v3/guides/) to learn about event handling, searching, getting directions, display settings and more.

## Work with MapsIndoors SDK behind a Firewall

If you need to work with MapsIndoors SDK behind a firewall, you might need to [allowlist some IP-addresses]({{ site.url }}/various/mapsindoors-sdk-firewall/).
