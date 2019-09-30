Add a `GoogleMap` and a `MapControl` to the class
```
MapControl mMapControl;
GoogleMap mGoogleMap;
```
The Venue's coordinates
```
static final LatLng VENUE_LAT_LNG = new LatLng( 57.05813067, 9.95058065 );
SupportMapFragment mMapFragment;
public ShowMultipleLocationsFragment()
{
    // Required empty public constructor
}
@NonNull
public static ShowMultipleLocationsFragment newInstance()
{
    return new ShowMultipleLocationsFragment();
}
//region FRAGMENT LIFECYCLE
@Override
@Nullable
public View onCreateView( @NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState )
{
    // Inflate the layout for this fragment
    return inflater.inflate( R.layout.fragment_map, container, false );
}
@Override
public void onViewCreated( @NonNull View view, @Nullable Bundle savedInstanceState )
{
    super.onViewCreated( view, savedInstanceState );
    setupView( view );
}
@Override
public void onDestroyView()
{
    if( mMapControl != null )
    {
        MapsIndoors.removeLocationSourceOnStatusChangedListener( locationSourceOnStatusChangedListener );
        mMapControl.onDestroy();
    }
    super.onDestroyView();
}
//endregion
private void setupView( View rootView )
{
    final FragmentManager fm = getChildFragmentManager();
    mMapFragment = (SupportMapFragment) fm.findFragmentById( R.id.mapfragment );
    mMapFragment.getMapAsync( mOnMapReadyCallback );
}
OnMapReadyCallback mOnMapReadyCallback = new OnMapReadyCallback() {
    @Override
    public void onMapReady( GoogleMap googleMap )
    {
        mGoogleMap = googleMap;
        mGoogleMap.moveCamera( CameraUpdateFactory.newLatLngZoom( VENUE_LAT_LNG, 13.0f ) );
        setupMapsIndoors();
    }
};
void setupMapsIndoors()
{
    final Activity context = getActivity();
    if( (context == null) || (mMapFragment == null) || (mMapFragment.getView() == null) )
    {
        return;
    }
    if( !MapsIndoors.getAPIKey().equalsIgnoreCase( getString( R.string.mi_api_key ) ) )
    {
        MapsIndoors.setAPIKey( getString( R.string.mi_api_key ) );
    }
    mMapControl = new MapControl( context );
    mMapControl.setGoogleMap( mGoogleMap, mMapFragment.getView() );
    //
    MapsIndoors.addLocationSourceOnStatusChangedListener( locationSourceOnStatusChangedListener );
    // Initialize MapControl. In this case we only need to know when locations are ready
    mMapControl.init( null );
}
void queryLocation()
{
```
 Setup a query with the string "Toilet" 
```
MPQuery query = new MPQuery.Builder().
        setQuery( "Toilet" ).
        build();
```
 Init the filter builder and build a filter, the criteria in this case we want maximum 50 toilets from the 1st floor 
 Get up to 50 toilets from the first floor, from any building and venue 
```
MPFilter filter = new MPFilter.Builder().
        setTake( 50 ).
        setFloorIndex( 1 ).
        build();
```
 Query the data 
```
MapsIndoors.getLocationsAsync(query, filter, (locs, err) -> {
    if(locs != null && locs.size() != 0 ){
        mMapControl.displaySearchResults( locs, true, 40 );
    }
});
l MPLocationSourceOnStatusChangedListener locationSourceOnStatusChangedListener = new MPLocationSourceOnStatusChangedListener()
@Override
public void onStatusChanged( @NonNull MPLocationSourceStatus status, int sourceId )
{
    if( status == MPLocationSourceStatus.AVAILABLE ) {
        final Activity context = getActivity();
        if( context != null ) {
            context.runOnUiThread( () -> {
                final List<MPLocation> locations = MapsIndoors.getLocations();
                if( locations.size() == 0 ) {
                    if( BuildConfig.DEBUG){}
                }
                //
                mMapControl.selectFloor( 1 );
                //
                queryLocation();
            } );
        }
    }
}
```

[See the sample in ShowMultipleLocationsFragment.java](https://github.com/MapsIndoors/MapsIndoorsAndroid-Demo-Samples/blob/master/app/src/main/java/com/mapsindoors/showmultiplelocations/ShowMultipleLocationsFragment.java)
