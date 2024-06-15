//package com.example.iseeapp2;
//
//
//import java.io.IOException;
//import java.util.List;
//import java.util.Locale;
//
//import javax.naming.Context;
//
//public class LocationHelper {
//
//    private Context mContext;
//    private LocationManager mLocationManager;
//    private LocationListener mLocationListener;
//
//    public LocationHelper(Context context) {
//        mContext = context;
//        mLocationManager = (LocationManager) mContext.getSystemService(Context.LOCATION_SERVICE);
//        mLocationListener = new LocationListener() {
//            @Override
//            public void onLocationChanged(Location location) {
//                // Xử lý việc lấy địa chỉ từ vị trí tại đây
//                getAddressFromLocation(location);
//            }
//
//            @Override
//            public void onStatusChanged(String provider, int status, Bundle extras) {
//            }
//
//            @Override
//            public void onProviderEnabled(String provider) {
//            }
//
//            @Override
//            public void onProviderDisabled(String provider) {
//            }
//        };
//    }
//
//    public void requestLocationUpdates() {
//        if (mLocationManager != null) {
//            mLocationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, mLocationListener);
//        }
//    }
//
//    public void removeLocationUpdates() {
//        if (mLocationManager != null) {
//            mLocationManager.removeUpdates(mLocationListener);
//        }
//    }
//
//    private void getAddressFromLocation(Location location) {
//        Geocoder geocoder = new Geocoder(mContext, Locale.getDefault());
//        try {
//            List<Address> addresses = geocoder.getFromLocation(location.getLatitude(), location.getLongitude(), 1);
//            if (addresses != null && !addresses.isEmpty()) {
//                Address address = addresses.get(0);
//                String addressLine = address.getAddressLine(0);
//                // Gửi địa chỉ đến Flutter thông qua kênh nào đó (ví dụ: platform channels)
//            }
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//    }
//}
//
